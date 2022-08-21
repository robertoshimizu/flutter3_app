# Login Presenter

## Requisitos
1. call Authentication with email and password
2. notify isLoadingStream before call Authentication
3. notify isLoadingStream after Authentication returns a response
4. notify loginAuthController in case Authetication returns an error
5. CLose all streams in dispose