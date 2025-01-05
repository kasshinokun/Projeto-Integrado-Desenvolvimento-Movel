package com.test_db.main;


/*
Need some adaptations for Code in this project

Created by Rodrigo Henriques da Silva Leone

Created on 15/06/2024 

Source-base URL: https://cursos.alura.com.br/forum/topico-projeto-alternativa-de-api-para-traducao-433467


*/

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

@JsonIgnoreProperties(ignoreUnknown = true)
public record DadosTraducao(DadosResposta responseData) {
    @JsonIgnoreProperties(ignoreUnknown = true)
    public static class DadosResposta {
        public String translatedText;
    }
}