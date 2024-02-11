from inc import *

# Generating text from neural-chat
def stream(text_input):
    return ollama.chat(model="neural-chat",
                         messages=[{"role": "system", "content": "You're an assistant."},
                         {'role':'user', 'content': text_input}],stream=True)

# main view function
def ai_model():
    req = request.get_json()
    keyword = req['keyword']
    def gen_text():
        for chunk in stream(keyword):
            yield chunk['message']['content']
    return gen_text(), {"Content-Type":'text/event-stream'}

    