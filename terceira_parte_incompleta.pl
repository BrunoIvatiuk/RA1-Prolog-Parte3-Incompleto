% trilhas disponíveis (formato: trilha(Trilha, Descrição))

trilha(dev_web, "Desenvolvedor WEB - Desenvolve páginas web, com foco maior em front-end.").
trilha(dev_software, "Desenvolvedor Back End - Desenvolve aplicativos e programas, com foco maior em back-end.").
trilha(ciencia_dados, "Ciência de dados - Analisa e trata dados em larga escala.").
trilha(redes_infra, "Redes - Constrói e mantém sistemas de rede com VPNs, Firewalls, VLANs, etc.").
trilha(cyber_sec, "Cibersegurança - Garante a segurança do sistema da empresa, com criptografias e afins.").

% base fixa de perguntas (formato: pergunta(Pergunta, Pred))

pergunta("Você deseja seguir algo com foco em programação", programa).
pergunta("Você gosta de trabalhar com design", design).
pergunta("Você lida bem com pressão", lida_pressao).
pergunta("Você lida bem com responsabilidade", lida_responsa).
pergunta("Você gosta de arquitetar e administrar sistemas", arq_admin).
pergunta("Você tem facilide com programação back-end", back_end).
pergunta("Você tem facilidade com programação front-end", front_end).
pergunta("Você tem experiência com criptografias diversas", criptografia).
pergunta("Você gosta de trabalhar com hardware", hardware).
pergunta("Você tem facilidade em encontrar falhas onde outras pessoas tem dificuldade", ve_falhas).


% peso de cada habilidade para cada trilha (formato: peso(Pred, Trilha, Peso).

peso(programa, dev_web, 5).
peso(programa, dev_software, 5).
peso(programa, ciencia_dados, 2).
peso(programa, redes_infra, 1).
peso(programa, cyber_sec, 3).

peso(design, dev_web, 5).
peso(design, dev_software, 3).
peso(design, ciencia_dados, 1).
peso(design, redes_infra, 2).
peso(design, cyber_sec, 1).

peso(lida_pressao, dev_web, 4).
peso(lida_pressao, dev_software, 4).
peso(lida_pressao, ciencia_dados, 2).
peso(lida_pressao, redes_infra, 2).
peso(lida_pressao, cyber_sec, 2).

peso(lida_responsa, dev_web, 2).
peso(lida_responsa, dev_software, 2).
peso(lida_responsa, ciencia_dados, 4).
peso(lida_responsa, redes_infra, 4).
peso(lida_responsa, cyber_sec, 5).

peso(arq_admin, dev_web, 1).
peso(arq_admin, dev_software, 1).
peso(arq_admin, ciencia_dados, 4).
peso(arq_admin, redes_infra, 5).
peso(arq_admin, cyber_sec, 1).

peso(back_end, dev_web, 3).
peso(back_end, dev_software, 5).
peso(back_end, ciencia_dados, 3).
peso(back_end, redes_infra, 1).
peso(back_end, cyber_sec, 4).

peso(front_end, dev_web, 5).
peso(front_end, dev_software, 3).
peso(front_end, ciencia_dados, 1).
peso(front_end, redes_infra, 1).
peso(front_end, cyber_sec, 2).

peso(criptografia, dev_web, 2).
peso(criptografia, dev_software, 1).
peso(criptografia, ciencia_dados, 3).
peso(criptografia, redes_infra, 3).
peso(criptografia, cyber_sec, 5).

peso(hardware, dev_web, 1).
peso(hardware, dev_software, 2).
peso(hardware, ciencia_dados, 1).
peso(hardware, redes_infra, 5).
peso(hardware, cyber_sec, 2).

peso(ve_falhas, dev_web, 3).
peso(ve_falhas, dev_software, 3).
peso(ve_falhas, ciencia_dados, 2).
peso(ve_falhas, redes_infra, 4).
peso(ve_falhas, cyber_sec, 4).


% --funções--


fazer_perguntas(Respostas) :-
    % funcao para criar uma lista com as respostas das perguntas
    findall(resposta(Pred, V),
        perguntar(Pred, V),
        Respostas).

perguntar(Pred, V) :-
    % funcao para fazer uma pergunta e armazenar o texto respondido no terminal pelo usuario
    pergunta(Pergunta, Pred),
    format("~w (s/n)? ", [Pergunta]),
    read(Resp),
    (Resp == s ->  V = true ; V = false).



calcular_resultado(Respostas, Pontuacao) :-
    % funcao para criar uma lista com as pontuações em cada trilha com base nas respostas
    findall(Pontos-Trilha,
            calcular(Respostas, Trilha, Pontos),
            Pontuacao).

calcular(Respostas, Trilha, Pontos) :-
    % funcao para contar a quantidade de pontos de uma trilha
    % trilha(Trilha, _Descricao) seleciona uma trilha e findall soma os pesos da trilha
    % onde a resposta foi verdadeira
    trilha(Trilha, _Descricao),
    findall(P,
            (member(resposta(Pred, true), Respostas), peso(Pred, Trilha, P)),
            Pesos),
    somaLista(Pesos, Pontos).

% funcao para somar os valores da lista
somaLista([], 0).
somaLista([H|T], Soma) :-
    somaLista(T, SomaResto),
    Soma is H + SomaResto.



recomendar_trilha(Respostas, Pontuacao) :-
    % funcao para ordenar as recomendações e inciar as impressões
    keysort(Pontuacao, P_Crescente),
    reverse(P_Crescente, P_Decrescente),
    imprimir_recomendacao(Respostas, P_Decrescente).


imprimir_recomendacao(Respostas, [_Pontos-Trilha|Resto]) :-
    % funcao para imprimir as recomendações, imprime a mais recomendada e a
	% justificativa, além de chamar a função para imprimir o resto das recomendações
    trilha(Trilha, Descricao),
	format("Trilha mais recomendada: ~w ~n", [Descricao]),
    writeln("Perguntas que mais influenciaram a recomendação: "),
    encontrar_justificativas(Respostas, Trilha),
    format("~nOutras trilhas em ordem de mais recomendada para menos recomendada:~n"),
    imprimir_outras_trilhas(Resto).


encontrar_justificativas(Respostas, Trilha) :-
    % funcao para encontrar as perguntas com peso 4 ou 5 para a trilha mais recomendada
	% e que foram responsidadas como sim pelo usuário
    findall(Justificativa,
            (member(resposta(Pred, true), Respostas), peso(Pred, Trilha, Peso), Peso >= 4, pergunta(Justificativa, Pred)),
            Justificativas),
    imprimir_justificativas(Justificativas).

% funcao para imprimir as perguntas que justificaram a recomendação
imprimir_justificativas([]).
imprimir_justificativas([H|T]) :-
    format("~w? ~n", H),
    imprimir_justificativas(T).    

% funcao para imprimir o resto das trilhas em ordem de mais recomandada para menos recomendada
imprimir_outras_trilhas([]).
imprimir_outras_trilhas([_Pontos-Trilha|Resto]) :-
    trilha(Trilha, Descricao),
    format("~w ~n", [Descricao]),
    imprimir_outras_trilhas(Resto).
	

iniciar :-
    fazer_perguntas(Respostas),
    calcular_resultado(Respostas, Pontuacao),
	recomendar_trilha(Respostas, Pontuacao).

