#include "poll_lookup.h"

/*
 * main
 *
 * Arguments: argc, argv
 *
 * Operation: Main driver for the program, calls other funttions to:
 *            parse the options, allocate the hash table, load the table, print
 *out the table stats
 *            and make print population stats of the desired city/state
 * Returns:   EXIT_SUCCESS if all ok, EXIT_FAILURE otherwise
 */
int main(int argc, char* argv[]) {
	node** table;
	unsigned long size = TABLE_SIZE;
	// name of csv file
	char* filename;
	int info = 0;

	// Indicates days we want stats for/to remove
	char* date = NULL;
	char* del_date = NULL;

	// Parse options
	if (!parse_opts(argc, argv, &filename, &size, &info, &date, &del_date)) {
		return EXIT_FAILURE;
	}

	// Allocate space for table
	if ((table = calloc(size, sizeof(node*))) == NULL) {
		fprintf(stderr, "%s: Unable to allocate space for hash table\n", argv[0]);
		return EXIT_FAILURE;
	}

	// Load records from file
	if (load_table(table, size, filename)) {
		return EXIT_FAILURE;
	}

	// Delete data first
	if (del_date) {
		char* stripped_date = strip_date(del_date);
		if (stripped_date) { // no malloc fail
			delete_date(table, size, stripped_date);
			free(stripped_date);
		} else {
			return EXIT_FAILURE;
		}
	}

	// Produce data for a single date
	if (date) {
		char* stripped_date = strip_date(date);
		if (stripped_date) { // no malloc fail
			print_date_stats(table, size, stripped_date);
			free(stripped_date);
		} else {
			return EXIT_FAILURE;
		}
	}

	// Print metadata
	if (info) print_info(table, size);

	// Clean up
	delete_table(table, size);

	return EXIT_SUCCESS;
}

/*
 * hash
 *
 * Arguments: a null terminated string
 *
 * Operation: calculates a hash value for the string
 *
 * returns:   the hash value
 */
unsigned long hash(char* str) {
	unsigned long hash = 0;
	unsigned int c;
	while ((c = (unsigned char) *str++) != '\0') {
		hash = c + (hash << 6) + (hash << 16) - hash;
	}
	return hash;
}