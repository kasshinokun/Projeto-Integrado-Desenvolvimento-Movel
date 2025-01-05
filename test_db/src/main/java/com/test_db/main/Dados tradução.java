package com.test_db.main;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

@JsonIgnoreProperties(ignoreUnknown = true)
public record DadosTraducao(DadosResposta responseData) {
    @JsonIgnoreProperties(ignoreUnknown = true)
    public static class DadosResposta {
        public String translatedText;
    }
}