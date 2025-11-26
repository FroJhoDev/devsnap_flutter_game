![Dart Version](https://img.shields.io/static/v1?label=dart&message=3.10.0&color=00579d)
![Flutter Version](https://img.shields.io/static/v1?label=flutter&message=3.24.0&color=42a5f5)
![Null Safety](https://img.shields.io/static/v1?label=null-safety&message=done&color=success)

# **🃏 DevSnap: Jogo de Cartas de Tecnologias**

## 📃 Sobre

> **DevSnap** é um jogo de cartas estratégico desenvolvido em Flutter que traz as principais tecnologias de programação para um duelo épico. Cada carta representa uma linguagem ou framework popular, com atributos únicos de custo, HP (pontos de vida) e ATK (ataque). Enfrente a IA em partidas táticas onde cada decisão conta!

### **Principais Recursos**

- 🎮 **Gameplay Estratégico**: Sistema de turnos com fases de compra, jogo e combate
- 🤖 **IA Inteligente**: Oponente controlado por IA com tomada de decisões estratégicas
- 🎨 **Visual Moderno**: Interface com Material Design 3 e Google Fonts
- 🔥 **Flame Engine**: Motor de jogos 2D integrado ao Flutter
- 🃏 **15 Cartas Únicas**: Flutter, Dart, Python, Java, JavaScript, TypeScript, React, Angular, Swift, Kotlin, PHP, Ruby, Go, SQL e C#
- ⚡ **Animações Fluidas**: Componentes visuais desenvolvidos com Flame
- 💎 **Sistema de Recursos**: Gerenciamento de moedas e compras táticas
- 📊 **Gestão de Estado**: Arquitetura MVVM com Provider

### **Mecânica do Jogo**

- 💰 **Fase de Compra**: Use moedas para adquirir cartas do deck
- 🎯 **Fase de Jogo**: Posicione suas cartas no tabuleiro estrategicamente
- ⚔️ **Fase de Combate**: Cartas atacam automaticamente causando e recebendo dano
- 🏆 **Vitória**: Elimine todas as cartas do oponente para vencer

### **Cartas Disponíveis**

| Carta | Custo | HP | ATK | Descrição |
|-------|-------|----|----|-----------|
| PHP | 1 | 2 | 1 | Old Guard |
| JavaScript | 2 | 2 | 2 | Wildcard |
| Dart | 2 | 3 | 2 | Speedster |
| Flutter | 3 | 4 | 2 | UI Avenger |
| Python | 3 | 3 | 3 | Sage |
| React | 3 | 4 | 2 | Component Hero |
| TypeScript | 3 | 4 | 3 | Type Safety |
| Angular | 4 | 5 | 2 | Framework Fortress |
| Java | 4 | 5 | 3 | The Tank |
| Swift | 4 | 4 | 3 | Apple Warrior |
| Kotlin | 4 | 4 | 3 | Modern JVM |
| Go | 5 | 6 | 4 | Concurrency Master |
| SQL | 2 | 3 | 2 | Data Commander |
| Ruby | 3 | 3 | 3 | Elegant Code |
| C# | 4 | 5 | 3 | .NET Champion |

---

## 🚀 Configurando para Utilizar

### **Pré-requisitos**

#### **Instalação do Flutter**

Certifique-se de que o Flutter SDK está instalado e configurado:

```bash
flutter doctor
```

Se não tiver o Flutter instalado, siga as [instruções oficiais](https://docs.flutter.dev/get-started/install).

### **Inicializando o Projeto**

1. Clone o repositório:
   ```bash
   git clone https://github.com/FroJhoDev/devsnap_flutter_game.git
   ```

2. Acesse a pasta do projeto:
   ```bash
   cd devsnap
   ```

3. Instale as dependências:
   ```bash
   flutter pub get
   ```

4. Execute o projeto:
   ```bash
   flutter run
   ```

---

## 🧩 Guidelines

### **Commits Pattern**

- **feat:** Nova funcionalidade
- **fix:** Correção de bugs
- **style:** Alterações de estilo/formatação
- **refactor:** Melhorias de código sem mudança funcional
- **docs:** Documentação
- **perf:** Otimizações de performance
- **test:** Testes
- **chore:** Configurações e dependências

Exemplo:
```bash
git commit -m "feat: adiciona sistema de combate entre cartas"
```

### **Branch Pattern**

- **main:** Código estável em produção
- **develop:** Integração de funcionalidades
- **feature/nome-da-feature:** Novas funcionalidades
- **fix/nome-do-bug:** Correções

Exemplo:
```bash
git checkout -b feature/multiplayer-mode
```

---

## 📐 Arquitetura Geral

### **Princípios**

- **MVVM Pattern:** Model-View-ViewModel para separação de responsabilidades
- **Component-Based:** Flame components para elementos do jogo
- **Service Layer:** Serviços especializados (AI, Deck, Turn Management)
- **State Management:** Provider/ChangeNotifier para reatividade
- **Immutability:** Equatable para comparações eficientes

### **Estrutura de Camadas**

#### **1. Presentation Layer** (`/lib/ui/`)
- **Views:** Telas do aplicativo (MainMenu, GameScreen)
- **Flame Components:** BoardComponent, CardComponent para renderização

#### **2. ViewModel Layer** (`/lib/viewmodels/`)
- **GameViewModel:** Gerenciamento central do estado do jogo
- Integra serviços e notifica a UI de mudanças

#### **3. Models** (`/lib/models/`)
- **CardModel:** Dados e atributos das cartas
- **GameState:** Estado global do jogo (fases, rodadas, vencedor)
- **PlayerModel:** Dados do jogador (mão, tabuleiro, deck, moedas)

#### **4. Services** (`/lib/services/`)
- **DeckService:** Criação e gerenciamento do deck
- **AIService:** Lógica de decisão da IA
- **TurnService:** Controle de fases e turnos

#### **5. Flame Components** (`/lib/flame_components/`)
- **DevSnapGame:** FlameGame principal
- **BoardComponent:** Renderização do tabuleiro
- **CardComponent:** Visualização e interação com cartas

### **Fluxo de Jogo**

```
MainMenuScreen → GameScreen → DevSnapGame (Flame) → BoardComponent
                      ↓
              GameViewModel (Provider)
                      ↓
         ┌────────────┼────────────┐
         ↓            ↓            ↓
    TurnService  AIService   DeckService
         ↓            ↓            ↓
              GameState Update
                      ↓
              UI Notification
```

---

## 🗃️ Definition

### **Pacotes e Ferramentas Principais**

#### **Game Engine**
- **flame:** ^1.34.0 - Motor 2D para jogos em Flutter
- **provider:** ^6.1.5 - Gerenciamento de estado

#### **UI/UX**
- **google_fonts:** ^6.3.2 - Tipografia customizada (Roboto Mono)
- **cupertino_icons:** ^1.0.8 - Ícones iOS

#### **Utilitários**
- **equatable:** ^2.0.7 - Comparação eficiente de objetos
- **uuid:** ^4.5.2 - Geração de IDs únicos
- **json_annotation:** ^4.9.0 - Serialização JSON

#### **Dev Tools**
- **build_runner:** ^2.10.4 - Geração de código
- **json_serializable:** ^6.11.3 - Serialização automática

### **Funcionalidades Dart/Flutter**

- **Null Safety:** Código seguro contra null
- **Material Design 3:** UI moderna e responsiva
- **ChangeNotifier:** Padrão Observer para reatividade
- **Custom Painting:** Renderização customizada com Flame
- **Asset Management:** Gestão de imagens das cartas

---

## 🎯 Como Funciona

### **Fluxo de Uma Rodada**

1. **💰 Fase de Compra (Draw Phase)**
   - Jogador e IA recebem moedas (+1 por rodada)
   - Possibilidade de comprar cartas do deck (custo variável)
   - Cartas compradas vão para a mão

2. **🎯 Fase de Jogo (Play Phase)**
   - Jogador posiciona cartas da mão no tabuleiro
   - IA toma decisões baseadas em heurísticas
   - Máximo de cartas no tabuleiro por jogador

3. **⚔️ Fase de Combate (Combat Phase)**
   - Cartas no tabuleiro atacam simultaneamente
   - Dano é aplicado (ATK de uma carta reduz HP da outra)
   - Cartas com HP ≤ 0 são removidas

4. **🔄 Fim do Turno (End Turn)**
   - Verifica condições de vitória
   - Incrementa contador de rodadas
   - Retorna à fase de compra

### **Sistema de IA**

```dart
AIService
├── decideBuyCard() → Analisa custo/benefício
├── decidePlayCard() → Posicionamento estratégico
└── evaluateCardValue() → HP + ATK como métrica
```

A IA prioriza:
- Comprar cartas de alto valor quando tem moedas
- Jogar cartas de maior poder total
- Conservar moedas quando necessário

---

## 🛠️ Desenvolvimento

### **Estrutura do Projeto**

```
lib/
├── main.dart                      # Entry point
├── flame_components/              # Componentes Flame
│   ├── dev_snap_game.dart        # FlameGame principal
│   ├── board_component.dart       # Tabuleiro visual
│   └── card_component.dart        # Renderização de cartas
├── models/                        # Modelos de dados
│   ├── card_model.dart           # Definição de carta
│   ├── card_model.g.dart         # Serialização gerada
│   ├── game_state.dart           # Estado global
│   └── player_model.dart         # Dados do jogador
├── services/                      # Lógica de negócio
│   ├── ai_service.dart           # Inteligência artificial
│   ├── deck_service.dart         # Gerenciamento de deck
│   └── turn_service.dart         # Sistema de turnos
├── viewmodels/                    # ViewModels
│   └── game_view_model.dart      # Estado do jogo
└── ui/                           # Interface
    └── views/
        ├── main_menu_screen.dart # Menu principal
        └── game_screen.dart      # Tela de jogo
```

### **Comandos Úteis**

```bash
# Desenvolvimento
flutter run --debug

# Build para Android
flutter build apk --release

# Build para iOS  
flutter build ios --release

# Gerar código (models)
flutter pub run build_runner build --delete-conflicting-outputs

# Análise de código
flutter analyze

# Testes
flutter test
```

---

## 🎨 Assets

### **Imagens Incluídas**

O projeto inclui 16 assets de cartas personalizados:

```
assets/images/
├── angular_card_front.png
├── c#_card_front.png
├── flutter_card_front.png
├── go_card_front.png
├── java_card_front.png
├── javascript_card_front.png
├── kotlin_card_front.png
├── php_card_front.png
├── python_card_front.png
├── react_card_front.png
├── ruby_card_front.png
├── sql_card_front.png
├── swift_card_front.png
├── typescript_card_front.png
├── card_default_back.png
└── board_background.png
```

---

## 📱 Compatibilidade

- **Plataformas:** Android, iOS, Web, Windows, macOS, Linux
- **Flutter:** 3.24.0+
- **Dart:** 3.10.0+
- **Engine:** Flame 1.34.0+

---

## 🎮 Futuras Melhorias

- [ ] Sistema de pontuação e ranking
- [ ] Modo multiplayer online
- [ ] Mais cartas e habilidades especiais
- [ ] Sistema de decks customizáveis
- [ ] Animações de combate aprimoradas
- [ ] Efeitos sonoros e música
- [ ] Tutorial interativo
- [ ] Diferentes níveis de dificuldade da IA

---

## 🤝 Contribuição

1. Fork o projeto
2. Crie uma branch para sua feature (`git checkout -b feature/nova-funcionalidade`)
3. Commit suas mudanças (`git commit -am 'feat: adiciona nova funcionalidade'`)
4. Push para a branch (`git push origin feature/nova-funcionalidade`)
5. Abra um Pull Request

---

## 📄 Licença

Este projeto está sob a licença MIT. Veja o arquivo `LICENSE` para detalhes.

---

## 👨‍💻 Desenvolvido por

**FroJhoDev**

Projeto criado para demonstrar desenvolvimento de jogos em Flutter com Flame Engine, arquitetura MVVM e inteligência artificial. 🚀🎮
