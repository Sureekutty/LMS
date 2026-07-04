package com.lms.app.security;

import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.web.authentication.WebAuthenticationDetailsSource;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;
import java.io.IOException;

@Component
public class JwtAuthFilter extends OncePerRequestFilter {

    @Autowired
    private JwtUtils jwtUtils;

    @Autowired
    private CustomUserDetailsService userDetailsService;

    @Override
    protected void doFilterInternal(HttpServletRequest request,
                                    HttpServletResponse response,
                                    FilterChain filterChain)
            throws ServletException, IOException {

        // Get token from header or query param
        String authHeader = request.getHeader("Authorization");
        String token = null;
        String username = null;

        // Check if header starts with "Bearer "
        if (authHeader != null && authHeader.startsWith("Bearer ")) {
            token = authHeader.substring(7);
        }
        
        // If not found in header, check query parameter (for file downloads)
        if (token == null && request.getParameter("token") != null) {
            token = request.getParameter("token");
        }

        if (token != null) {
            try {
                username = jwtUtils.getUsernameFromToken(token);
            } catch (Exception e) {
                // Log and ignore to allow request to continue (Spring Security will block if endpoint requires auth)
                logger.warn("JWT validation failed: " + e.getMessage());
            }
        }

        // Validate token and set authentication
        if (username != null && 
            SecurityContextHolder.getContext().getAuthentication() == null) {
            
            UserDetails userDetails = userDetailsService.loadUserByUsername(username);
            
            if (jwtUtils.validateToken(token)) {
                UsernamePasswordAuthenticationToken authToken =
                    new UsernamePasswordAuthenticationToken(
                        userDetails, null, userDetails.getAuthorities());
                authToken.setDetails(
                    new WebAuthenticationDetailsSource().buildDetails(request));
                SecurityContextHolder.getContext().setAuthentication(authToken);
            }
        }
        filterChain.doFilter(request, response);
    }
}