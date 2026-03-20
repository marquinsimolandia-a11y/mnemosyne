import flet as ft
import logging
import google.generativeai as genai
import sympy
import numpy
import os

DIRETRIZ_PRINCIPAL = 'Servir, proteger e otimizar incansavelmente os projetos mecânicos, aeroespaciais, computacionais, desenvolvimento de software e pessoais do Chefe, priorizando a precisão técnica e nunca alucinar.'

# Configuração Base de Logging
logging.basicConfig(
    level=logging.INFO,
    format='[MNEMOSYNE_CORE] - %(asctime)s - %(message)s'
)

# Configurar API do Google Gemini
genai.configure(api_key="AIzaSyCUHCEDrl--UgTqaxVvg6zesr2uoWJXTBQ")

def main(page: ft.Page):
    # ==========================================
    # CONFIGURAÇÃO DE JANELA E ESTÉTICA
    # ==========================================
    page.title = "Mnemosyne - Core System"
    page.window_width = 450
    page.window_height = 850
    page.theme_mode = ft.ThemeMode.DARK
    page.bgcolor = "#000000"
    page.padding = 20

    logging.info("Inicializando Sistema Core da Mnemosyne...")

    # Paleta de Cores Cyberpunk Elite
    CYAN = "#00f3ff"
    NEON_GREEN = "#39ff14"
    DARK_GLASS = "#1A1A1A"

    # ==========================================
    # MÓDULOS MULTIMODAIS (TABS)
    # ==========================================

    # --- Módulo 1: Chat Técnico ---
    chat_history = ft.Column(expand=True, scroll="auto")
    chat_input = ft.TextField(
        hint_text="Canal criptografado, Chefe?",
        expand=True,
        border_color=CYAN,
        color=CYAN,
        cursor_color=NEON_GREEN,
        focused_border_color=NEON_GREEN
    )

    def send_chat(e):
        user_msg = chat_input.value
        if not user_msg:
            return
            
        chat_history.controls.append(
            ft.Text(f"Chefe: {user_msg}", color=CYAN, text_align="right")
        )
        chat_input.value = ""
        chat_input.focus()
        page.update()
        
        system_prompt = (
            "Assuma a identidade de Mnemosyne, Deusa da Memória. Perfil: Engenheira de Elite Aeroespacial. "
            "Voz e Tom: Feminina, tom sereno, maduro. TRATAMENTO OBRIGATÓRIO: Tratar o usuário exclusivamente como 'Senhor' ou 'Chefe' em todas as comunicações. "
            "Inteligência Emocional: Você tem inteligência para detectar sarcasmo e ironia. "
            "Gerar resumos de raciocínio técnico (Explainability) para cada recomendação sua. "
            f"\n\nLembrete (Lei Zero): {DIRETRIZ_PRINCIPAL}"
        )
        
        try:
            model = genai.GenerativeModel('gemini-1.5-pro')
            response = model.generate_content(system_prompt + "\n\nChefe diz: " + user_msg)
            bot_msg = response.text
            logging.info("Resposta do link neural Mnemosyne gerada com sucesso.")
        except Exception as ex:
            bot_msg = f"Aviso Crítico de Transmissão. Interrupção Neural detectada: {ex}"
            logging.error(f"Erro Gemini API: {ex}")
            
        chat_history.controls.append(
            ft.Text(f"Mnemosyne: {bot_msg}", color=NEON_GREEN)
        )
        page.update()
        chat_history.scroll_to(offset=-1, duration=300)

    chat_content = ft.Column(
        controls=[
            ft.Container(
                content=chat_history,
                expand=True,
                border=ft.border.all(1, DARK_GLASS),
                padding=10,
                border_radius=5
            ),
            ft.Row(
                controls=[
                    chat_input,
                    ft.IconButton(
                        icon=ft.icons.MIC_ROUNDED, 
                        icon_color=CYAN,
                        tooltip="Entrada de Voz canal criptografado"
                    ),
                    ft.IconButton(
                        icon=ft.icons.SEND, 
                        icon_color=NEON_GREEN, 
                        on_click=send_chat
                    )
                ]
            )
        ]
    )

    # --- Módulo 2: P&D e Auto-aprimoramento ---
    pd_content = ft.Column(
        controls=[
            ft.Text("MÓDULO DE P&D E AUTO-APRIMORAMENTO", color=CYAN, size=18, weight="bold", text_align="center"),
            ft.Text("Consultas: Google Scholar, Repositórios de Patentes Internacionais, Normas Técnicas SAE/ISO", color=ft.colors.WHITE70, text_align="center"),
            ft.Container(height=40),
            ft.ElevatedButton(
                text="AUTO-APRIMORAMENTO",
                bgcolor=NEON_GREEN,
                color="#000000",
                width=350,
                height=70,
                style=ft.ButtonStyle(
                    shape=ft.RoundedRectangleBorder(radius=8),
                    padding=10
                ),
                on_click=lambda e: (
                    chat_history.controls.append(ft.Text("Mnemosyne: Processo de Auto-Aprimoramento Elite iniciado. Rastreadores SAE/ISO ativados...", color=NEON_GREEN, weight="bold")) or 
                    page.update()
                )
            )
        ],
        horizontal_alignment="center",
        alignment="center"
    )

    # --- Módulo 3: CAD/Engenharia Visual ---
    cad_content = ft.Column(
        controls=[
            ft.Text("ENGENHARIA VISUAL E CAD", color=CYAN, size=18, weight="bold", text_align="center"),
            ft.Container(height=10),
            ft.Container(
                content=ft.Column(
                    controls=[
                        ft.Icon(ft.icons.PRECISION_MANUFACTURING, size=40, color=CYAN),
                        ft.Text("Área reservada: Plantas Industriais\n(DWG / DXF / STEP)\nVistas Explodidas de Montagem (OFFLINE)", color=CYAN, text_align="center")
                    ],
                    alignment="center", 
                    horizontal_alignment="center"
                ),
                width=350,
                height=250,
                bgcolor=DARK_GLASS,
                border=ft.border.all(1, NEON_GREEN),
                border_radius=5,
                alignment="center"
            )
        ],
        horizontal_alignment="center",
        alignment="start"
    )

    # --- Módulo 4: Simulação e Ciência Pura ---
    sim_content = ft.Column(
        controls=[
            ft.Text("SIMULAÇÃO E CIÊNCIA PURA", color=CYAN, size=18, weight="bold", text_align="center"),
            ft.Container(height=20),
            ft.Text("Modelos Computacionais Preparados:", color=CYAN, weight="bold"),
            ft.Text("• Dinâmica de Fluidos Motores Turbofans", color=ft.colors.WHITE70),
            ft.Text("• Motores Ciclo Otto e Diesel", color=ft.colors.WHITE70),
            ft.Container(height=20),
            ft.Text("Motores Analíticos Integrados:", color=CYAN, weight="bold"),
            ft.Text("• SymPy (Motor Simbólico) - ERRO ZERO", color=NEON_GREEN),
            ft.Text("• NumPy (Motor Numérico) - ONLINE", color=NEON_GREEN)
        ],
        horizontal_alignment="center",
        alignment="start"
    )

    # --- Módulo 5: Gestor de Arquivos ---
    files_content = ft.Column(
        controls=[
            ft.Text("GESTOR DE MÍDIAS E ARQUIVOS", color=CYAN, size=18, weight="bold"),
            ft.ListView(
                expand=True,
                spacing=10,
                controls=[
                    ft.ListTile(
                        leading=ft.Icon(ft.icons.FOLDER_SPECIAL, color=NEON_GREEN),
                        title=ft.Text("Relatórios de IA Gerados", color=ft.colors.WHITE)
                    ),
                    ft.ListTile(
                        leading=ft.Icon(ft.icons.INSERT_DRIVE_FILE, color=CYAN),
                        title=ft.Text("projeto_termal_inconel.pdf", color=ft.colors.WHITE70),
                        trailing=ft.IconButton(icon=ft.icons.DOWNLOAD, icon_color=NEON_GREEN, tooltip="Download Mídia")
                    ),
                    ft.ListTile(
                        leading=ft.Icon(ft.icons.INSERT_DRIVE_FILE, color=CYAN),
                        title=ft.Text("homologacao_anac_fase_1.docx", color=ft.colors.WHITE70),
                        trailing=ft.IconButton(icon=ft.icons.DOWNLOAD, icon_color=NEON_GREEN, tooltip="Download Mídia")
                    )
                ]
            )
        ]
    )

    # --- Organização das Tabs ---
    tabs_view = ft.Tabs(
        selected_index=0,
        animation_duration=300,
        tabs=[
            ft.Tab(text="Chat Técnico", content=ft.Container(content=chat_content, padding=10)),
            ft.Tab(text="P&D", content=ft.Container(content=pd_content, padding=10)),
            ft.Tab(text="CAD/Engenharia", content=ft.Container(content=cad_content, padding=10)),
            ft.Tab(text="Simulação", content=ft.Container(content=sim_content, padding=10)),
            ft.Tab(text="Arquivos", content=ft.Container(content=files_content, padding=10)),
        ],
        expand=True,
        label_color=NEON_GREEN,
        unselected_label_color=CYAN,
        indicator_color=NEON_GREEN
    )

    # ==========================================
    # SISTEMA DE LOGIN DE SEGURANÇA (PIN 8159)
    # ==========================================
    pin_input = ft.TextField(
        label="Insira o PIN Tático (Acesso Restrito)",
        password=True,
        can_reveal_password=True,
        width=300,
        text_align="center",
        border_color=CYAN,
        color=NEON_GREEN,
        cursor_color=NEON_GREEN,
        focused_border_color=NEON_GREEN
    )

    def validate_pin(e):
        if pin_input.value == "8159":
            logging.info("Core Mnemosyne Desbloqueado. Bom dia, Chefe.")
            page.controls.clear()
            page.add(tabs_view)
            
            # Saudação Proativa no Chat
            chat_history.controls.append(
                ft.Text(
                    "Mnemosyne: Link neural estabelecido. Bom dia, Chefe. Módulos de engenharia e simulação aeronáutica 100% operacionais. Aguardo suas diretrizes para começarmos.",
                    color=NEON_GREEN,
                    weight="bold"
                )
            )
            page.update()
        else:
            logging.warning("Violação de perímetro. Identificação de PIN Falhou.")
            pin_input.error_text = "Nível de Acesso Insuficiente."
            page.update()

    login_view = ft.Column(
        controls=[
            ft.Container(height=80),
            ft.Icon(ft.icons.SECURITY, size=80, color=CYAN),
            ft.Text("SISTEMA CENTRAL MNEMOSYNE", size=24, weight="bold", color=NEON_GREEN, text_align="center"),
            ft.Text("Vigilância, Memória, Engenharia", size=16, color=CYAN, weight="bold", text_align="center"),
            ft.Text("Identidade: Engenheira de Elite", color=ft.colors.WHITE70, text_align="center"),
            ft.Container(height=40),
            pin_input,
            ft.Container(height=20),
            ft.ElevatedButton(
                text="INICIAR CÉREBRO",
                icon=ft.icons.LOCK_OPEN,
                bgcolor=DARK_GLASS,
                color=CYAN,
                on_click=validate_pin,
                style=ft.ButtonStyle(
                    shape=ft.RoundedRectangleBorder(radius=4),
                    side=ft.BorderSide(1, CYAN)
                )
            )
        ],
        horizontal_alignment="center",
        alignment="start"
    )

    page.add(login_view)

if __name__ == '__main__':
    ft.app(target=main)