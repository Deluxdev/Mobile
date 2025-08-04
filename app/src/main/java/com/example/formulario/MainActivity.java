package com.example.formulario;

import android.app.DatePickerDialog;
import android.os.Bundle;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.EditText;
import android.widget.Spinner;
import android.widget.Toast;
import androidx.appcompat.app.AppCompatActivity;
import java.util.Calendar;

public class MainActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        // Configura o Spinner de sexo
        Spinner spinnerSexo = findViewById(R.id.spinnerSexo);
        ArrayAdapter<CharSequence> adapter = ArrayAdapter.createFromResource(
                this,
                R.array.sexo_array,
                android.R.layout.simple_spinner_item
        );
        adapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);
        spinnerSexo.setAdapter(adapter);

        // Campos e botão
        Button btnCadastrar = findViewById(R.id.btnCadastrar);
        EditText inputNome = findViewById(R.id.inputNome);
        EditText inputDataNascimento = findViewById(R.id.inputDataNascimento);

        // Impede que abra teclado
        inputDataNascimento.setFocusable(false);
        inputDataNascimento.setClickable(true);

        // Quando clicar no campo de data → abre calendário
        inputDataNascimento.setOnClickListener(v -> {
            Calendar calendario = Calendar.getInstance();
            int ano = calendario.get(Calendar.YEAR);
            int mes = calendario.get(Calendar.MONTH);
            int dia = calendario.get(Calendar.DAY_OF_MONTH);

            DatePickerDialog datePicker = new DatePickerDialog(
                    this,
                    (view, anoSelecionado, mesSelecionado, diaSelecionado) -> {
                        mesSelecionado++; // Ajusta mês (0-11 para 1-12)
                        String dataFormatada = String.format("%02d-%02d-%04d", diaSelecionado, mesSelecionado, anoSelecionado);
                        inputDataNascimento.setText(dataFormatada);
                    },
                    ano, mes, dia
            );
            datePicker.show();
        });

        // Botão cadastrar
        btnCadastrar.setOnClickListener(v -> {
            String nome = inputNome.getText().toString().trim();
            String dataNascimentoStr = inputDataNascimento.getText().toString().trim();

            // Verifica campos
            if (nome.isEmpty() || dataNascimentoStr.isEmpty()) {
                Toast.makeText(this, "Preencha todos os campos", Toast.LENGTH_SHORT).show();
                return;
            }

            try {
                String[] partes = dataNascimentoStr.split("-");
                int dia = Integer.parseInt(partes[0]);
                int mes = Integer.parseInt(partes[1]);
                int ano = Integer.parseInt(partes[2]);

                Calendar hoje = Calendar.getInstance();
                int idade = hoje.get(Calendar.YEAR) - ano;

                if (hoje.get(Calendar.MONTH) + 1 < mes ||
                        (hoje.get(Calendar.MONTH) + 1 == mes && hoje.get(Calendar.DAY_OF_MONTH) < dia)) {
                    idade--;
                }

                if (idade < 18) {
                    Toast.makeText(this, "Cadastro permitido apenas para maiores de 18 anos", Toast.LENGTH_SHORT).show();
                } else {
                    Toast.makeText(this, "Cadastro permitido!", Toast.LENGTH_SHORT).show();
                }

            } catch (Exception e) {
                Toast.makeText(this, "Data de nascimento inválida", Toast.LENGTH_SHORT).show();
            }
        });
    }
}