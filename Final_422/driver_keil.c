extern void _bzero( void*, int ); 
extern char* _strncpy( char*, char*, int );
extern void* _malloc( int );
extern void _free( void* );
extern void* _memcpy( );
extern void* _signal( int signum, void (*fn)(int) );
extern unsigned int _alarm( unsigned int );

/*Extra Credit 
extern int _string_to_int(char* string_in);
extern int _string_length(const char* in_string);
extern int _string_comp(const char* string1, const char* string2);
extern void _string_copy(char* _dest_string, const char* source_string);

#define RESULT_ADDRESS ((char*)0x20000010)
*/

#define SIG_ALRM 14

/*Extra Credit  
	char str1[] = "This is the final project!";
	char str2[] = "This is the final project!";
	char str3[] = "CSS422";

	// Compare strings
	if (_string_comp(str1, str2) == 0) {
			*((int*)RESULT_ADDRESS) = 1;  // Strings are equal
	} else {
			*((int*)RESULT_ADDRESS) = 0;  // Strings are not equal
	}

	if (_string_comp(str1, str3) == 0) {
			*((int*)(RESULT_ADDRESS + 4)) = 1;  // Strings are equal
	} else {
			*((int*)(RESULT_ADDRESS + 4)) = 0;  // Strings are not equal
	}

	// Copy string to destination
	char destination[50];
	_string_copy(destination, "This is the final project!");
	for (int i = 0; i < 50; i++) {
			RESULT_ADDRESS[i + 8] = destination[i];  // Store copied string
	}

	// Convert string to integer
	*((int*)(RESULT_ADDRESS + 58)) = _string_to_int("12345");  // Store integer result

	// Get string length
	*((int*)(RESULT_ADDRESS + 62)) = _string_length("CSS422");  // Store length result
*/
	
int* alarmed;

void sig_handler1( int signum ) {
	*alarmed = 2;
}

void sig_handler2( int signum ) {
	*alarmed = 3;
}

int main( ) {
	char stringA[40] = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabc\0";
  char stringB[40];
	
  //_bzero( stringB, 40 );
	_strncpy( stringB, stringA, 40 );
	_bzero( stringA, 40 );
	
  void* mem1 = _malloc( 1024 );
	void* mem2 = _malloc( 1024 );
	void* mem3 = _malloc( 8192 );
	void* mem4 = _malloc( 4096 );
	void* mem5 = _malloc( 512 );
	void* mem6 = _malloc( 1024 );
	void* mem7 = _malloc( 512 );
	
	_free( mem6 );
	_free( mem5 );
	_free( mem1 );
	_free( mem7 );
	_free( mem2 );
	
	
	void* mem8 = _malloc( 4096 );
	_free( mem4 );
	_free( mem3 );
	_free( mem8 );
	
	alarmed = (int *)_malloc( 4 );
	*alarmed = 1;
	
	_signal( SIG_ALRM, sig_handler1 );
	_alarm( 2 );
	
	while ( *alarmed != 2 ) {
		void* mem9 = _malloc( 4 );	
		_free( mem9 );		
	}
	
	_signal( SIG_ALRM, sig_handler2 );
	_alarm( 3 );
	
	while ( *alarmed != 3 ) {
		void* mem9 = _malloc( 4 );	
		_free( mem9 );
	}
	
	return 0;
}