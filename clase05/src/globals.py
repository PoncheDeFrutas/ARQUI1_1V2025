class GlobalState:
    """
    Singleton class to manage global shared state across the application.
    Attributes:
        temperature (float): Shared variable to store temperature value.
        humidity (float): Shared variable to store humidity value.
        local_error_message (str): Shared variable to store local error messages.
    Methods:
        __new__(cls): Ensures only one instance of GlobalState exists (Singleton pattern).
        _init(self): Initializes shared state variables.
    """
    _instance = None                                   
    
    def __new__(cls):                                       # Singleton pattern
        if cls._instance is None:
            cls._instance = super().__new__(cls)
            cls._instance._init()
        return cls._instance
    
    def _init(self):                                        # Initialize shared variables
        self.temperature = 0.0
        self.humidity = 0.0
        # Add other shared variables here if needed
        self.local_error_message = ""



        

shared = GlobalState()  # Create a shared instance of GlobalState