 CREATE TABLE IF NOT EXISTS Paciente (
   id_paciente INTEGER PRIMARY KEY,
   nome VARCHAR(200),
   cpf VARCHAR(20) NOT NULL UNIQUE,
   rg VARCHAR(20) NOT NULL UNIQUE,
   data_nascimento DATE NOT NULL,
   genero VARCHAR(50),
   estado_civil VARCHAR(100),
   logradouro VARCHAR(100) NOT NULL,
   numero INTEGER NOT NULL,
   complemento VARCHAR(100) NOT NULL,
   bairro VARCHAR(100) NOT NULL,
   cidade VARCHAR(100) NOT NULL,
   uf VARCHAR(100) NOT NULL,
   cep VARCHAR(100) NOT NULL,
   telefone VARCHAR(50) NOT NULL,
   email VARCHAR(100) NOT NULL,
   tipo_sanguineo CHAR(3),
   alergias VARCHAR(100),
   condicoes_preexistentes VARCHAR(200),
   medicamentos_uso_continuo VARCHAR(200)
   );

   CREATE TABLE IF NOT EXISTS Responsável_Financeiro(
   	id_responsavel INTEGER PRIMARY KEY AUTOINCREMENT,
	nome_completo VARCHAR(200) NOT NULL,
    cpf VARCHAR(100) NOT NULL UNIQUE,
    telefone VARCHAR(100) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE
   );

   CREATE TABLE IF NOT EXISTS Convenio(
   	id_convenio INTEGER PRIMARY KEY AUTOINCREMENT,
	nome VARCHAR(200) NOT NULL,
    cnpj VARCHAR(100) NOT NULL UNIQUE,
    razao_social VARCHAR(100) NOT NULL
   );

CREATE TABLE IF NOT EXISTS Paciente_Convenio(
   	id_paciente_convenio INTEGER PRIMARY KEY AUTOINCREMENT,
    id_paciente INTEGER NOT NULL,
   	id_convenio INTEGER NOT NULL,
    numero_carteirinha INTEGER NOT NULL,
    plano VARCHAR(100) NOT NULL,
    validade DATETIME NOT NULL,
    FOREIGN KEY (id_paciente) REFERENCES Paciente(id_paciente) ON DELETE CASCADE,
    FOREIGN KEY (id_convenio) REFERENCES Convenio(id_convenio) ON DELETE CASCADE
   );

  CREATE TABLE IF NOT EXISTS Termo_Consentimento(
   	id_termo INTEGER PRIMARY KEY AUTOINCREMENT,
    id_paciente INTEGER NOT NULL,
    data_assinatura DATETIME NOT NULL,
    tipo_assinatura VARCHAR(100),
    FOREIGN KEY (id_paciente) REFERENCES Paciente(id_paciente)
   );

 	CREATE TABLE Profissional_Saude (
    id_profissional INTEGER PRIMARY KEY AUTOINCREMENT,
    nome_completo VARCHAR(255) NOT NULL,
    cpf VARCHAR(14) UNIQUE NOT NULL,
    crm_conselho VARCHAR(50),
    uf_conselho CHAR(2),
    data_nascimento DATE,
    tipo_contrato VARCHAR(20) CHECK (tipo_contrato IN ('CLT', 'PJ', 'Cooperado')),
    data_inicio DATE
	);

CREATE TABLE Especialidade (
id_especialidade INTEGER PRIMARY KEY AUTOINCREMENT,
nome VARCHAR(100) NOT NULL
);

CREATE TABLE Profissional_Especialidade (
id_profissional_especialidade INTEGER PRIMARY KEY AUTOINCREMENT,
id_profissional INT REFERENCES Profissional_Saude(id_profissional) ON DELETE CASCADE,
id_especialidade INT REFERENCES Especialidade(id_especialidade) ON DELETE CASCADE,
rqe VARCHAR(50)
);

CREATE TABLE Sala (
id_sala INTEGER PRIMARY KEY AUTOINCREMENT,
numero VARCHAR(10) NOT NULL,
tipo VARCHAR(50) CHECK (tipo IN ('consultório', 'sala de exame')),
recursos_disponiveis TEXT
);

CREATE TABLE Agenda_Profissional (
id_agenda INTEGER PRIMARY KEY AUTOINCREMENT,
id_profissional INT REFERENCES Profissional_Saude(id_profissional) ON DELETE CASCADE,
dia_semana VARCHAR(10) CHECK (dia_semana IN ('segunda', 'terça', 'quarta', 'quinta', 'sexta', 'sábado', 'domingo')),
hora_inicio TIME NOT NULL,
hora_fim TIME NOT NULL,
id_sala INT REFERENCES Sala(id_sala)
);

CREATE TABLE Consulta (
id_consulta INTEGER PRIMARY KEY AUTOINCREMENT ,
id_paciente INT NOT NULL,
id_profissional INT REFERENCES Profissional_Saude(id_profissional),
id_sala INT REFERENCES Sala(id_sala),
id_convenio INT,
data DATE NOT NULL,
hora_inicio TIME NOT NULL,
hora_fim_prevista TIME,
status VARCHAR(20) CHECK (status IN ('agendada', 'confirmada', 'cancelada', 'realizada', 'no-show')),
motivo_cancelamento TEXT,
tipo_consulta VARCHAR(100),
observacoes_pre_consulta TEXT
);

CREATE TABLE Prontuario (
id_prontuario INTEGER PRIMARY KEY AUTOINCREMENT ,
id_consulta INT REFERENCES Consulta(id_consulta),
id_paciente INT NOT NULL,
id_profissional INT REFERENCES Profissional_Saude(id_profissional),
data_hora_atendimento TIMESTAMP NOT NULL,
queixa_principal TEXT,
hda TEXT,
exame_fisico TEXT,
hipoteses_diagnosticas TEXT,
diagnosticos_confirmados TEXT,
plano_terapeutico TEXT
);

CREATE TABLE Exame_Solicitado (
id_exame INTEGER PRIMARY KEY AUTOINCREMENT,
id_prontuario INT REFERENCES Prontuario(id_prontuario) ON DELETE CASCADE,
nome_exame VARCHAR(255),
data_solicitacao DATE,
resultado TEXT
);

CREATE TABLE Medicamento (
id_medicamento INTEGER PRIMARY KEY AUTOINCREMENT,
nome VARCHAR(255),
principio_ativo VARCHAR(255),
laboratorio VARCHAR(255)
);

CREATE TABLE Medicamento_Prescrito (
id_prescricao INTEGER PRIMARY KEY AUTOINCREMENT,
id_prontuario INT REFERENCES Prontuario(id_prontuario) ON DELETE CASCADE,
id_medicamento INT REFERENCES Medicamento(id_medicamento),
dosagem VARCHAR(100),
posologia VARCHAR(255),
via_administracao VARCHAR(100),
duracao_tratamento VARCHAR(100)
);

CREATE TABLE Atestado_Declaracao (
id_documento INTEGER PRIMARY KEY AUTOINCREMENT,
id_prontuario INT REFERENCES Prontuario(id_prontuario) ON DELETE CASCADE,
tipo_documento VARCHAR(20) CHECK (tipo_documento IN ('atestado', 'declaração')),
conteudo TEXT
);

CREATE TABLE Pagamento (
id_pagamento INTEGER PRIMARY KEY AUTOINCREMENT,
id_consulta INT REFERENCES Consulta(id_consulta),
id_responsavel INT NOT NULL,
data_pagamento DATE,
valor_total DECIMAL(10,2),
forma_pagamento VARCHAR(20) CHECK (forma_pagamento IN ('dinheiro', 'cartão', 'pix', 'convênio')),
status_convenio VARCHAR(20) CHECK (status_convenio IN ('enviado', 'glosado', 'pago')),
valor_glosa DECIMAL(10,2),
data_recebimento_convenio DATE
);
