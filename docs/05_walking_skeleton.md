This is going to be first epic that we will define both in github issues and in github wiki

We will create basic framework for interaction of the user with LLM. 

Every interaction LLM will be logged, both request and response.

LLM interactions will include configurable context prompts. For example for interaction related to creation of the vision document system will provide a context that will include prompts like "in this session you are assisting user in creation of the vision statement for the project and the format of the output will include following sections {you will insert relevant information here}". In addition system will retrieve relevant context (for example existing vision statement, description of the type of the organization) as well as relevant RAG based context that could be previous conversations, documents in github wiki, or uploaded documents, parsed websites. Once response is received next action will be determined which can be asking users for additional questions, updating document user is currently working on, commiting changes to github wiki, github issues, vetorising and storing in posgresql db copies of github wiki document with the status proposed change or commit or previous_version, github issues should be done on approval of the document change.

When documenting this epic, features and user stories you will follow logical progression for example first feature could be user LLM interaction and stories could be establishing connectivity to openapi with simple request response as a test, next story could be creating a web page with text box for user input, text box or similar for LLM output and button to send the message including mock of the openai api which could be a simple echo to start. 

At the end of this epic we wold like to have an application which shows document user is working on in markdown preview with option to switch it to edit mode. LLM will progressively update document based on user prompts and also have output section of the page where it can ask user for clarifying questions. For now LLM logging will go to the service that simply outputs to system out. later we will implement posgresql database for storing conversations in vectors, conersation logs, user configuration etc.

ask me additional questions about how to format output of this (wiki page for the feature and when we are done and i approve you to do so github issues for the epic, feature and user stories)

relevant context to consider:
- docs/vision.md
- development.md





