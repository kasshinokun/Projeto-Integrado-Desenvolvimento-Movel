package br.com.test_db.main;


/*
Need some adaptations for Code in this project

Created by Rodrigo Henriques da Silva Leone

Created on 15/06/2024 

Source-base URL: https://cursos.alura.com.br/forum/topico-projeto-alternativa-de-api-para-traducao-433467


*/

import br.com.test_db.main.DadosTraducao;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;

import java.net.URLEncoder;

public class translate {

public class ConsultaMyMemory {
    public static String obterTraducao(String text) {
        ObjectMapper mapper = new ObjectMapper();

        ConsumoApi consumo = new ConsumoApi();

        String texto = URLEncoder.encode(text);
        String langpair = URLEncoder.encode("en|pt-br");

        String url = "https://api.mymemory.translated.net/get?q=" + texto + "&langpair=" + langpair;

        String json = consumo.obterDados(url);

        DadosTraducao traducao;
        try {
            traducao = mapper.readValue(json, DadosTraducao.class);
        } catch (JsonProcessingException e) {
            throw new RuntimeException(e);
        }

        return traducao.responseData().translatedText;
    }
}

}