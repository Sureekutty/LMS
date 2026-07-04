package com.lms.app.service;

import com.lms.app.model.InterestRate;
import com.lms.app.repository.InterestRateRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class InterestRateService {

    @Autowired
    private InterestRateRepository interestRateRepository;

    public List<InterestRate> getAllRates() {
        return interestRateRepository.findAll();
    }

    public Optional<InterestRate> getRateById(Long id) {
        return interestRateRepository.findById(id);
    }

    public List<InterestRate> getRatesByTypeCode(String typeCode) {
        return interestRateRepository.findByTypeCode(typeCode);
    }

    public InterestRate saveRate(InterestRate interestRate) {
        return interestRateRepository.save(interestRate);
    }

    public InterestRate updateRate(InterestRate interestRate) {
        if (interestRate.getId() == null || !interestRateRepository.existsById(interestRate.getId())) {
            throw new RuntimeException("Cannot update non-existent interest rate rule.");
        }
        return interestRateRepository.save(interestRate);
    }

    public void deleteRate(Long id) {
        if (!interestRateRepository.existsById(id)) {
            throw new RuntimeException("Interest rate rule not found with ID: " + id);
        }
        interestRateRepository.deleteById(id);
    }
}
