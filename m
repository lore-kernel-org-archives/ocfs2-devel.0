From: Goldwyn Rodrigues <rgoldwyn@gmail.com>
Date: Wed Jan 23 01:47:59 2008
Subject: [Ocfs2-devel] /etc/mkfs.ocfs2.conf support
Message-ID: <20080123094730.GA18317@baloo.nue.novell.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com


Changes to support mkfs.ocfs2.conf
Mostly picked from e2fsprogs

--- 
diff --git a/mkfs.ocfs2/Makefile b/mkfs.ocfs2/Makefile
index 00d9d22..7c3c0f5 100644
--- a/mkfs.ocfs2/Makefile
+++ b/mkfs.ocfs2/Makefile
@@ -28,7 +28,7 @@ LIBO2DLM_DEPS = $(TOPDIR)/libo2dlm/libo2dlm.a
 INCLUDES = -I$(TOPDIR)/include -I.
 DEFINES = -DVERSION=\"$(VERSION)\"
 
-CFILES = mkfs.c check.c
+CFILES = prof_err.c profile.c mkfs.c check.c
 HFILES = mkfs.h
 
 OBJS = $(subst .c,.o,$(CFILES))
@@ -40,4 +40,12 @@ DIST_FILES = $(CFILES) $(HFILES) mkfs.ocfs2.8.in
 mkfs.ocfs2: $(OBJS) $(LIBOCFS2_DEPS) $(LIBO2DLM_DEPS) $(LIBO2CB_DEPS)
 	$(LINK) $(LIBOCFS2_LIBS) $(LIBO2DLM_LIBS) $(LIBO2CB_LIBS) $(COM_ERR_LIBS) $(UUID_LIBS)
 
+prof_err.c prof_err.h: prof_err.et
+	compile_et prof_err.et
+
+CLEAN_RULES = clean-err
+
+clean-err:
+	rm -f prof_err.c prof_err.h
+
 include $(TOPDIR)/Postamble.make
diff --git a/mkfs.ocfs2/mkfs.c b/mkfs.ocfs2/mkfs.c
index 0ade0ab..610b994 100644
--- a/mkfs.ocfs2/mkfs.c
+++ b/mkfs.ocfs2/mkfs.c
@@ -24,6 +24,9 @@
  */
 
 #include "mkfs.h"
+#include "profile.h"
+
+profile_t profile;
 
 static State *get_state(int argc, char **argv);
 static int get_number(char *arg, uint64_t *res);
@@ -507,11 +510,104 @@ parse_fs_type_opts(char *progname, const char *typestr,
 	}
 }
 
+static void syntax_err_report(const char *filename, long err, int line_num)
+{
+	fprintf(stderr, "Syntax error in mke2fs config file (%s, line #%d)\n\t%s\n", filename, line_num, error_message(err));
+	exit(1);
+}
+
+
+static const char *config_fn[] = { "/etc/mkfs.ocfs2.conf", 0 };
+static const char *default_files[] = { "<default>", 0 };
+const char *mkfs_default_profile = 
+  "[defaults]\n"
+  "	block-size = 4096\n"
+  "\n"
+  "[fs_types]\n"
+  "	datafiles = {\n"
+  "		journal = {\n"
+  "			size = 8192\n"
+  "		}\n"
+  "	}\n"
+;
+
+static int get_uint_from_profile(const char *category,const char *name, unsigned int value)
+{
+	const char	*names[4];
+	if (value>0)
+		return value;
+
+	names[0] = strdup("defaults");
+	names[1] = name;
+	names[2] = 0;
+	names[3] = 0;
+
+	profile_get_uint(profile, names, 0, &value);
+	free((void *)names[0]);
+
+	names[0] = strdup("fs_types");
+	names[1] = category;
+	names[2] = name;
+	names[3] = 0;
+	profile_get_uint(profile, names, value, &value);
+	free((void *) names[0]);
+	return value;
+}
+
+static long long get_bytesize_from_profile(const char *category,const char *name, unsigned long long value)
+{
+	const char	*names[4];
+	if (value>0)
+		return value;
+
+	names[0] = strdup("defaults");
+	names[1] = name;
+	names[2] = 0;
+	profile_get_bytesize(profile, names, 0, &value);
+	free((void *)names[0]);
+
+	names[0] = strdup("fs_types");
+	names[1] = category;
+	names[2] = name;
+	names[3] = 0;
+	free((void *)names[0]);
+	profile_get_bytesize(profile, names, value, &value);
+	return value;
+}
+
+static long long get_journalsize_from_profile(const char *category, unsigned long long value)
+{
+	const char *names[5];
+	if (value>0)
+		return value;
+
+	names[0] = strdup("defaults");
+	names[1] = strdup("journal");
+	names[2] = strdup("size");
+	names[3] = 0;
+	profile_get_bytesize(profile, names, 0, &value);
+	free((void *)names[0]);
+	free((void *)names[1]);
+	free((void *)names[2]);
+
+	names[0] = strdup("fs_types");
+	names[1] = category;
+	names[2] = strdup("journal");
+	names[3] = strdup("size");
+	names[4] = 0;
+
+	profile_get_bytesize(profile, names, value, &value);
+	free((void *)names[0]);
+	free((void *)names[2]);
+	free((void *)names[3]);
+
+	return value;
+}
+
 static State *
 get_state(int argc, char **argv)
 {
 	char *progname;
-	unsigned int blocksize = 0;
 	unsigned int cluster_size = 0;
 	char *vol_label = NULL;
 	unsigned int initial_slots = 0;
@@ -524,11 +620,15 @@ get_state(int argc, char **argv)
 	int ret;
 	uint64_t val;
 	uint64_t journal_size_in_bytes = 0;
+	uint64_t blocksize = 0;
+	uint64_t blockscount = 0;
 	enum ocfs2_fs_types fs_type = FS_DEFAULT;
+	char *ft_str = NULL;
 	int mount = -1;
 	int no_backup_super = -1;
 	enum feature_level_indexes index = FEATURE_LEVEL_DEFAULT;
 	fs_options feature_flags ={0,0,0}, reverse_flags = {0,0,0};
+	char *tmp;
 
 	static struct option long_options[] = {
 		{ "block-size", 1, 0, 'b' },
@@ -548,6 +648,16 @@ get_state(int argc, char **argv)
 		{ 0, 0, 0, 0}
 	};
 
+	if ((tmp = getenv("MKFS_OCFS2_CONFIG")) != NULL)
+		config_fn[0] = tmp;
+	profile_set_syntax_err_cb(syntax_err_report);
+	ret = profile_init(config_fn, &profile);
+	if (ret == ENOENT) {
+		profile_init(default_files, &profile);
+		profile_set_default(profile, mkfs_default_profile);
+	}
+
+
 	if (argc && *argv)
 		progname = basename(argv[0]);
 	else
@@ -673,6 +783,7 @@ get_state(int argc, char **argv)
 
 		case 'T':
 			parse_fs_type_opts(progname, optarg, &fs_type);
+			ft_str = optarg;
 			break;
 
 		case BACKUP_SUPER_OPTION:
@@ -715,8 +826,7 @@ get_state(int argc, char **argv)
 	memset(s, 0, sizeof(State));
 
 	if (optind < argc) {
-		s->specified_size_in_blocks = strtoull(argv[optind], &dummy,
-						       0);
+		blockscount = strtoull(argv[optind], &dummy, 0);
 		if ((*dummy)) {
 			com_err(progname, 0, "Block count bad - %s",
 				argv[optind]);
@@ -735,15 +845,18 @@ get_state(int argc, char **argv)
 	if (show_version)
 		exit(0);
 
+	/* Read from the configuration file and set the values */
+	blocksize = get_bytesize_from_profile(ft_str,"block-size" , blocksize);
+	cluster_size =  get_bytesize_from_profile(ft_str, "cluster-size", cluster_size);
+	journal_size_in_bytes = get_journalsize_from_profile(ft_str, journal_size_in_bytes);
+	blockscount = get_bytesize_from_profile(ft_str, "blocks-count", blockscount);
+	initial_slots = get_uint_from_profile(ft_str, "number-of-nodes", initial_slots);
 
 	s->progname      = progname;
-
 	s->verbose       = verbose;
 	s->quiet         = quiet;
 	s->force         = force;
-
 	s->prompt        = xtool ? 0 : 1;
-
 	s->blocksize     = blocksize;
 	s->cluster_size  = cluster_size;
 	s->vol_label     = vol_label;
@@ -779,6 +892,7 @@ get_state(int argc, char **argv)
 	else
 		s->no_backup_super = 1;
 
+	s->specified_size_in_blocks = blockscount;
 
 	/* Here if the user set these flags explicitly, we will use them and
 	 * discard the setting in the features set.
diff --git a/mkfs.ocfs2/prof_err.et b/mkfs.ocfs2/prof_err.et
new file mode 100644
index 0000000..29250ea
--- /dev/null
+++ b/mkfs.ocfs2/prof_err.et
@@ -0,0 +1,47 @@
+error_table prof
+
+error_code	PROF_VERSION,	"Profile version 0.0"
+
+error_code	PROF_MAGIC_NODE,	"Bad magic value in profile_node"
+error_code	PROF_NO_SECTION,	"Profile section not found"
+error_code	PROF_NO_RELATION,	"Profile relation not found"
+error_code	PROF_ADD_NOT_SECTION, 
+	"Attempt to add a relation to node which is not a section"
+error_code	PROF_SECTION_WITH_VALUE, 
+	"A profile section header has a non-zero value"
+error_code	PROF_BAD_LINK_LIST, 	"Bad linked list in profile structures"
+error_code	PROF_BAD_GROUP_LVL, 	"Bad group level in profile strctures"
+error_code	PROF_BAD_PARENT_PTR, 	
+	"Bad parent pointer in profile strctures"
+error_code	PROF_MAGIC_ITERATOR,	"Bad magic value in profile iterator"
+error_code	PROF_SET_SECTION_VALUE,	"Can't set value on section node"
+error_code	PROF_EINVAL,		"Invalid argument passed to profile library"
+error_code	PROF_READ_ONLY,		"Attempt to modify read-only profile"
+
+error_code	PROF_SECTION_NOTOP, "Profile section header not at top level"
+error_code	PROF_SECTION_SYNTAX, "Syntax error in profile section header"
+error_code	PROF_RELATION_SYNTAX, "Syntax error in profile relation"
+error_code	PROF_EXTRA_CBRACE, "Extra closing brace in profile"
+error_code	PROF_MISSING_OBRACE, "Missing open brace in profile"
+
+error_code	PROF_MAGIC_PROFILE,	"Bad magic value in profile_t"
+error_code	PROF_MAGIC_SECTION,	"Bad magic value in profile_section_t"
+error_code	PROF_TOPSECTION_ITER_NOSUPP,
+	"Iteration through all top level section not supported"
+error_code	PROF_INVALID_SECTION,	"Invalid profile_section object"
+error_code	PROF_END_OF_SECTIONS,	"No more sections"
+error_code	PROF_BAD_NAMESET,	"Bad nameset passed to query routine"
+error_code	PROF_NO_PROFILE,	"No profile file open"
+
+error_code      PROF_MAGIC_FILE,	"Bad magic value in profile_file_t"
+error_code	PROF_FAIL_OPEN,		"Couldn't open profile file"
+
+error_code	PROF_EXISTS,		"Section already exists"
+
+error_code	PROF_BAD_BOOLEAN,		"Invalid boolean value"
+error_code	PROF_BAD_INTEGER,		"Invalid integer value"
+
+error_code	PROF_MAGIC_FILE_DATA, "Bad magic value in profile_file_data_t"
+
+
+end
diff --git a/mkfs.ocfs2/profile.c b/mkfs.ocfs2/profile.c
new file mode 100644
index 0000000..cea7c14
--- /dev/null
+++ b/mkfs.ocfs2/profile.c
@@ -0,0 +1,1387 @@
+/*
+ * profile.c -- A simple configuration file parsing "library in a file"
+ * 
+ * The profile library was originally written by Theodore Ts'o in 1995
+ * for use in the MIT Kerberos v5 library.  It has been
+ * modified/enhanced/bug-fixed over time by other members of the MIT
+ * Kerberos team.  This version was originally taken from the Kerberos
+ * v5 distribution, version 1.4.2, and radically simplified for use in
+ * e2fsprogs.  (Support for locking for multi-threaded operations,
+ * being able to modify and update the configuration file
+ * programmatically, and Mac/Windows portability have been removed.
+ * It has been folded into a single C source file to make it easier to
+ * fold into an application program.)
+ *
+ * Copyright (C) 2005, 2006 by Theodore Ts'o.
+ *
+ * %Begin-Header%
+ * This file may be redistributed under the terms of the GNU Public
+ * License.
+ * %End-Header%
+ * 
+ */
+
+#ifdef HAVE_UNISTD_H
+#include <unistd.h>
+#endif
+#include <stdio.h>
+#include <stdlib.h>
+#include <time.h>
+#include <string.h>
+#include <errno.h>
+#include <ctype.h>
+#include <limits.h>
+#include <stddef.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <dirent.h>
+#ifdef HAVE_PWD_H
+#include <pwd.h>
+#endif
+
+#include <et/com_err.h>
+#include "profile.h"
+#include "prof_err.h"
+
+#undef STAT_ONCE_PER_SECOND
+#undef HAVE_STAT
+
+/*
+ * prof_int.h
+ */
+
+typedef long prf_magic_t;
+
+/*
+ * This is the structure which stores the profile information for a
+ * particular configuration file.
+ */
+struct _prf_file_t {
+	prf_magic_t	magic;
+	char		*filespec;
+#ifdef STAT_ONCE_PER_SECOND
+	time_t		last_stat;
+#endif
+	time_t		timestamp; /* time tree was last updated from file */
+	int		flags;	/* r/w, dirty */
+	int		upd_serial; /* incremented when data changes */
+	struct profile_node *root;
+	struct _prf_file_t *next;
+};
+
+typedef struct _prf_file_t *prf_file_t;
+
+/*
+ * The profile flags
+ */
+#define PROFILE_FILE_RW		0x0001
+#define PROFILE_FILE_DIRTY	0x0002
+#define PROFILE_FILE_NO_RELOAD	0x0004
+
+/*
+ * This structure defines the high-level, user visible profile_t
+ * object, which is used as a handle by users who need to query some
+ * configuration file(s)
+ */
+struct _profile_t {
+	prf_magic_t	magic;
+	prf_file_t	first_file;
+};
+
+#define PROFILE_ITER_LIST_SECTION	0x0001
+#define PROFILE_ITER_SECTIONS_ONLY	0x0002
+#define PROFILE_ITER_RELATIONS_ONLY	0x0004
+
+#define PROFILE_ITER_FINAL_SEEN		0x0100
+
+/*
+ * Check if a filespec is last in a list (NULL on UNIX, invalid FSSpec on MacOS
+ */
+
+#define	PROFILE_LAST_FILESPEC(x) (((x) == NULL) || ((x)[0] == '\0'))
+
+struct profile_node {
+	errcode_t	magic;
+	char *name;
+	char *value;
+	int group_level;
+	unsigned int final:1;		/* Indicate don't search next file */
+	unsigned int deleted:1;
+	struct profile_node *first_child;
+	struct profile_node *parent;
+	struct profile_node *next, *prev;
+};
+
+#define CHECK_MAGIC(node) \
+	  if ((node)->magic != PROF_MAGIC_NODE) \
+		  return PROF_MAGIC_NODE;
+
+/* profile parser declarations */
+struct parse_state {
+	int	state;
+	int	group_level;
+	int	line_num;
+	struct profile_node *root_section;
+	struct profile_node *current_section;
+};
+
+static const char *default_filename = "<default>";
+
+static profile_syntax_err_cb_t	syntax_err_cb;
+
+static errcode_t parse_line(char *line, struct parse_state *state);
+
+static void profile_free_node
+	(struct profile_node *relation);
+
+static errcode_t profile_create_node
+	(const char *name, const char *value,
+		   struct profile_node **ret_node);
+
+static errcode_t profile_add_node
+	(struct profile_node *section,
+		    const char *name, const char *value,
+		    struct profile_node **ret_node);
+
+static errcode_t profile_find_node
+	(struct profile_node *section,
+		    const char *name, const char *value,
+		    int section_flag, void **state,
+		    struct profile_node **node);
+
+static errcode_t profile_node_iterator
+	(void	**iter_p, struct profile_node **ret_node,
+		   char **ret_name, char **ret_value);
+
+static errcode_t profile_open_file
+	(const char * file, prf_file_t *ret_prof);
+
+static errcode_t profile_update_file
+	(prf_file_t prf);
+
+static void profile_free_file
+	(prf_file_t profile);
+
+static errcode_t profile_get_value(profile_t profile, const char *names[],
+				   const char **ret_value);
+
+
+static int compstr(const void *m1, const void *m2) 
+{
+	const char *s1 = *((const char * const *) m1);
+	const char *s2 = *((const char * const *) m2);
+
+	return strcmp(s1, s2); 
+}
+
+static void free_list(char **list)
+{
+    char	**cp;
+
+    if (list == 0)
+	    return;
+    
+    for (cp = list; *cp; cp++)
+	free(*cp);
+    free(list);
+}
+
+static errcode_t get_dirlist(const char *dirname, char***ret_array)
+{
+	DIR *dir;
+	struct dirent *de;
+	struct stat st;
+	errcode_t retval;
+	char *fn, *cp;
+	char **array = 0, **new_array;
+	int max = 0, num = 0;
+
+	dir = opendir(dirname);
+	if (!dir)
+		return errno;
+
+	while ((de = readdir(dir)) != NULL) {
+		for (cp = de->d_name; *cp; cp++) {
+			if (!isalnum(*cp) &&
+			    (*cp != '-') &&
+			    (*cp != '_'))
+				break;
+		}
+		if (*cp)
+			continue;
+		fn = malloc(strlen(dirname) + strlen(de->d_name) + 2);
+		if (!fn) {
+			retval = ENOMEM;
+			goto errout;
+		}
+		sprintf(fn, "%s/%s", dirname, de->d_name);
+		if ((stat(fn, &st) < 0) || !S_ISREG(st.st_mode)) {
+			free(fn);
+			continue;
+		}
+		if (num >= max) {
+			max += 10;
+			new_array = realloc(array, sizeof(char *) * (max+1));
+			if (!new_array) {
+				retval = ENOMEM;
+				goto errout;
+			}
+			array = new_array;
+		}
+		array[num++] = fn;
+	}
+	if (array) {
+		qsort(array, num, sizeof(char *), compstr);
+		array[num++] = 0;
+	}
+	*ret_array = array;
+	closedir(dir);
+	return 0;
+errout:
+	closedir(dir);
+	free_list(array);
+	return retval;
+}
+
+errcode_t 
+profile_init(const char **files, profile_t *ret_profile)
+{
+	const char **fs;
+	profile_t profile;
+	prf_file_t  new_file, *last;
+	errcode_t retval = 0;
+	char **cpp, *cp, **array = 0;
+
+	profile = malloc(sizeof(struct _profile_t));
+	if (!profile)
+		return ENOMEM;
+	memset(profile, 0, sizeof(struct _profile_t));
+	profile->magic = PROF_MAGIC_PROFILE;
+	last = &profile->first_file;
+
+        /* if the filenames list is not specified return an empty profile */
+        if ( files ) {
+	    for (fs = files; !PROFILE_LAST_FILESPEC(*fs); fs++) {
+		retval = get_dirlist(*fs, &array);
+		if (retval == 0) {
+			if (!array)
+				continue;
+			for (cpp = array; (cp = *cpp); cpp++) {
+				retval = profile_open_file(cp, &new_file);
+				if (retval == EACCES)
+					continue;
+				if (retval)
+					goto errout;
+				*last = new_file;
+				last = &new_file->next;
+			}
+		} else if ((retval != ENOTDIR) && 
+			   strcmp(*fs, default_filename))
+			goto errout;
+
+		retval = profile_open_file(*fs, &new_file);
+		/* if this file is missing, skip to the next */
+		if (retval == ENOENT || retval == EACCES) {
+			continue;
+		}
+		if (retval)
+			goto errout;
+		*last = new_file;
+		last = &new_file->next;
+	    }
+	    /*
+	     * If all the files were not found, return the appropriate error.
+	     */
+	    if (!profile->first_file) {
+		profile_release(profile);
+		return ENOENT;
+	    }
+	}
+
+	free_list(array);
+        *ret_profile = profile;
+        return 0;
+errout:
+	free_list(array);
+	profile_release(profile);
+	return retval;
+}
+
+void 
+profile_release(profile_t profile)
+{
+	prf_file_t	p, next;
+
+	if (!profile || profile->magic != PROF_MAGIC_PROFILE)
+		return;
+
+	for (p = profile->first_file; p; p = next) {
+		next = p->next;
+		profile_free_file(p);
+	}
+	profile->magic = 0;
+	free(profile);
+}
+
+/*
+ * This function sets the value of the pseudo file "<default>".  If
+ * the file "<default>" had previously been passed to profile_init(),
+ * then def_string parameter will be parsed and used as the profile
+ * information for the "<default>" file.
+ */
+errcode_t profile_set_default(profile_t profile, const char *def_string)
+{
+	struct parse_state	state;
+	prf_file_t		prf;
+	errcode_t		retval;
+	const char		*in;
+	char			*line, *p, *end;
+	int			line_size, len;
+
+	if (!def_string || !profile || profile->magic != PROF_MAGIC_PROFILE)
+		return PROF_MAGIC_PROFILE;
+
+	for (prf = profile->first_file; prf; prf = prf->next) {
+		if (strcmp(prf->filespec, default_filename) == 0)
+			break;
+	}
+	if (!prf)
+		return 0;
+
+	if (prf->root) {
+		profile_free_node(prf->root);
+		prf->root = 0;
+	}
+
+	memset(&state, 0, sizeof(struct parse_state));
+	retval = profile_create_node("(root)", 0, &state.root_section);
+	if (retval)
+		return retval;
+
+	line = 0;
+	line_size = 0;
+	in = def_string;
+	while (*in) {
+		end = strchr(in, '\n');
+		len = end ? (end - in) : (int) strlen(in);
+		if (len >= line_size) {
+			line_size = len+1;
+			p = realloc(line, line_size);
+			if (!p) {
+				retval = ENOMEM;
+				goto errout;
+			}
+			line = p;
+		}
+		memcpy(line, in, len);
+		line[len] = 0;
+		retval = parse_line(line, &state);
+		if (retval) {
+		errout:
+			if (syntax_err_cb)
+				(syntax_err_cb)(prf->filespec, retval, 
+						state.line_num);
+			free(line);
+			if (prf->root)
+				profile_free_node(prf->root);
+			return retval;
+		}
+		if (!end)
+			break;
+		in = end+1;
+	}
+	prf->root = state.root_section;
+	free(line);
+
+	return 0;
+}
+
+errcode_t profile_open_file(const char * filespec,
+			    prf_file_t *ret_prof)
+{
+	prf_file_t	prf;
+	errcode_t	retval;
+	char		*home_env = 0;
+	unsigned int	len;
+	char		*expanded_filename;
+
+	prf = malloc(sizeof(struct _prf_file_t));
+	if (!prf)
+		return ENOMEM;
+	memset(prf, 0, sizeof(struct _prf_file_t));
+	prf->magic = PROF_MAGIC_FILE;
+
+	len = strlen(filespec)+1;
+	if (filespec[0] == '~' && filespec[1] == '/') {
+		home_env = getenv("HOME");
+#ifdef HAVE_PWD_H
+		if (home_env == NULL) {
+#ifdef HAVE_GETWUID_R
+		    struct passwd *pw, pwx;
+		    uid_t uid;
+		    char pwbuf[BUFSIZ];
+
+		    uid = getuid();
+		    if (!getpwuid_r(uid, &pwx, pwbuf, sizeof(pwbuf), &pw)
+			&& pw != NULL && pw->pw_dir[0] != 0)
+			home_env = pw->pw_dir;
+#else
+		    struct passwd *pw;
+
+		    pw = getpwuid(getuid());
+		    home_env = pw->pw_dir;
+#endif
+		}
+#endif
+		if (home_env)
+			len += strlen(home_env);
+	}
+	expanded_filename = malloc(len);
+	if (expanded_filename == 0) {
+	    profile_free_file(prf);	
+	    return errno;
+	}
+	if (home_env) {
+	    strcpy(expanded_filename, home_env);
+	    strcat(expanded_filename, filespec+1);
+	} else
+	    memcpy(expanded_filename, filespec, len);
+
+	prf->filespec = expanded_filename;
+
+	if (strcmp(prf->filespec, default_filename) != 0) {
+		retval = profile_update_file(prf);
+		if (retval) {
+			profile_free_file(prf);
+			return retval;
+		}
+	}
+
+	*ret_prof = prf;
+	return 0;
+}
+
+errcode_t profile_update_file(prf_file_t prf)
+{
+	errcode_t retval;
+#ifdef HAVE_STAT
+	struct stat st;
+#ifdef STAT_ONCE_PER_SECOND
+	time_t now;
+#endif
+#endif
+	FILE *f;
+	char buf[2048];
+	struct parse_state state;
+
+	if (prf->flags & PROFILE_FILE_NO_RELOAD)
+		return 0;
+
+#ifdef HAVE_STAT
+#ifdef STAT_ONCE_PER_SECOND
+	now = time(0);
+	if (now == prf->last_stat && prf->root != NULL) {
+	    return 0;
+	}
+#endif
+	if (stat(prf->filespec, &st)) {
+	    retval = errno;
+	    return retval;
+	}
+#ifdef STAT_ONCE_PER_SECOND
+	prf->last_stat = now;
+#endif
+	if (st.st_mtime == prf->timestamp && prf->root != NULL) {
+	    return 0;
+	}
+	if (prf->root) {
+		profile_free_node(prf->root);
+		prf->root = 0;
+	}
+#else
+	/*
+	 * If we don't have the stat() call, assume that our in-core
+	 * memory image is correct.  That is, we won't reread the
+	 * profile file if it changes.
+	 */
+	if (prf->root) {
+	    return 0;
+	}
+#endif
+	memset(&state, 0, sizeof(struct parse_state));
+	retval = profile_create_node("(root)", 0, &state.root_section);
+	if (retval)
+		return retval;
+	errno = 0;
+	f = fopen(prf->filespec, "r");
+	if (f == NULL) {
+		retval = errno;
+		if (retval == 0)
+			retval = ENOENT;
+		return retval;
+	}
+	prf->upd_serial++;
+	while (!feof(f)) {
+		if (fgets(buf, sizeof(buf), f) == NULL)
+			break;
+		retval = parse_line(buf, &state);
+		if (retval) {
+			if (syntax_err_cb)
+				(syntax_err_cb)(prf->filespec, retval, 
+						state.line_num);
+			fclose(f);
+			return retval;
+		}
+	}
+	prf->root = state.root_section;
+
+	fclose(f);
+
+#ifdef HAVE_STAT
+	prf->timestamp = st.st_mtime;
+#endif
+	return 0;
+}
+
+void profile_free_file(prf_file_t prf)
+{
+    if (prf->root)
+	profile_free_node(prf->root);
+    if (prf->filespec)
+	    free(prf->filespec);
+    free(prf);
+}
+
+/* Begin the profile parser */
+
+profile_syntax_err_cb_t profile_set_syntax_err_cb(profile_syntax_err_cb_t hook)
+{
+	profile_syntax_err_cb_t	old;
+
+	old = syntax_err_cb;
+	syntax_err_cb = hook;
+	return(old);
+}
+
+#define STATE_INIT_COMMENT	0
+#define STATE_STD_LINE		1
+#define STATE_GET_OBRACE	2
+
+static char *skip_over_blanks(char *cp)
+{
+	while (*cp && isspace((int) (*cp)))
+		cp++;
+	return cp;
+}
+
+static int end_or_comment(char ch)
+{
+	return (ch == 0 || ch == '#' || ch == ';');
+}
+
+static char *skip_over_nonblanks(char *cp)
+{
+	while (!end_or_comment(*cp) && !isspace(*cp))
+		cp++;
+	return cp;
+}
+
+static void strip_line(char *line)
+{
+	char *p = line + strlen(line);
+	while (p > line && (p[-1] == '\n' || p[-1] == '\r'))
+	    *p-- = 0;
+}
+
+static void parse_quoted_string(char *str)
+{
+	char *to, *from;
+
+	to = from = str;
+
+	for (to = from = str; *from && *from != '"'; to++, from++) {
+		if (*from == '\\') {
+			from++;
+			switch (*from) {
+			case 'n':
+				*to = '\n';
+				break;
+			case 't':
+				*to = '\t';
+				break;
+			case 'b':
+				*to = '\b';
+				break;
+			default:
+				*to = *from;
+			}
+			continue;
+		}
+		*to = *from;
+	}
+	*to = '\0';
+}
+
+static errcode_t parse_line(char *line, struct parse_state *state)
+{
+	char	*cp, ch, *tag, *value;
+	char	*p;
+	errcode_t retval;
+	struct profile_node	*node;
+	int do_subsection = 0;
+	void *iter = 0;
+	
+	state->line_num++;
+	if (state->state == STATE_GET_OBRACE) {
+		cp = skip_over_blanks(line);
+		if (*cp != '{')
+			return PROF_MISSING_OBRACE;
+		state->state = STATE_STD_LINE;
+		return 0;
+	}
+	if (state->state == STATE_INIT_COMMENT) {
+		if (line[0] != '[')
+			return 0;
+		state->state = STATE_STD_LINE;
+	}
+
+	if (*line == 0)
+		return 0;
+	strip_line(line);
+	cp = skip_over_blanks(line);
+	ch = *cp;
+	if (end_or_comment(ch))
+		return 0;
+	if (ch == '[') {
+		if (state->group_level > 0)
+			return PROF_SECTION_NOTOP;
+		cp++;
+		cp = skip_over_blanks(cp);
+		p = strchr(cp, ']');
+		if (p == NULL)
+			return PROF_SECTION_SYNTAX;
+		if (*cp == '"') {
+			cp++;
+			parse_quoted_string(cp);
+		} else {
+			*p-- = '\0';
+			while (isspace(*p) && (p > cp))
+				*p-- = '\0';
+			if (*cp == 0)
+				return PROF_SECTION_SYNTAX;
+		}
+		retval = profile_find_node(state->root_section, cp, 0, 1, 
+					   &iter, &state->current_section);
+		if (retval == PROF_NO_SECTION) {
+			retval = profile_add_node(state->root_section,
+						  cp, 0,
+						  &state->current_section);
+			if (retval)
+				return retval;
+		} else if (retval)
+			return retval;
+
+		/*
+		 * Finish off the rest of the line.
+		 */
+		cp = p+1;
+		if (*cp == '*') {
+			state->current_section->final = 1;
+			cp++;
+		}
+		/*
+		 * Spaces or comments after ']' should not be fatal 
+		 */
+		cp = skip_over_blanks(cp);
+		if (!end_or_comment(*cp))
+			return PROF_SECTION_SYNTAX;
+		return 0;
+	}
+	if (ch == '}') {
+		if (state->group_level == 0)
+			return PROF_EXTRA_CBRACE;
+		if (*(cp+1) == '*')
+			state->current_section->final = 1;
+		state->current_section = state->current_section->parent;
+		state->group_level--;
+		return 0;
+	}
+	/*
+	 * Parse the relations
+	 */
+	tag = cp;
+	cp = strchr(cp, '=');
+	if (!cp)
+		return PROF_RELATION_SYNTAX;
+	if (cp == tag)
+	    return PROF_RELATION_SYNTAX;
+	*cp = '\0';
+	if (*tag == '"') {
+		tag++;
+		parse_quoted_string(tag);
+	} else {
+		/* Look for whitespace on left-hand side.  */
+		p = skip_over_nonblanks(tag);
+		if (*p)
+			*p++ = 0;
+		p = skip_over_blanks(p);
+		/* If we have more non-whitespace, it's an error.  */
+		if (*p)
+			return PROF_RELATION_SYNTAX;
+	}
+
+	cp = skip_over_blanks(cp+1);
+	value = cp;
+	ch = value[0];
+	if (ch == '"') {
+		value++;
+		parse_quoted_string(value);
+	} else if (end_or_comment(ch)) {
+		do_subsection++;
+		state->state = STATE_GET_OBRACE;
+	} else if (value[0] == '{') {
+		cp = skip_over_blanks(value+1);
+		ch = *cp;
+		if (end_or_comment(ch))
+			do_subsection++;
+		else
+			return PROF_RELATION_SYNTAX;
+	} else {
+		cp = skip_over_nonblanks(value);
+		p = skip_over_blanks(cp);
+		ch = *p;
+		*cp = 0;
+		if (!end_or_comment(ch))
+			return PROF_RELATION_SYNTAX;
+	}
+	if (do_subsection) {
+		p = strchr(tag, '*');
+		if (p)
+			*p = '\0';
+		retval = profile_add_node(state->current_section,
+					  tag, 0, &state->current_section);
+		if (retval)
+			return retval;
+		if (p)
+			state->current_section->final = 1;
+		state->group_level++;
+		return 0;
+	}
+	p = strchr(tag, '*');
+	if (p)
+		*p = '\0';
+	profile_add_node(state->current_section, tag, value, &node);
+	if (p)
+		node->final = 1;
+	return 0;
+}
+
+/*
+ * 
+ * All of the details of how the tree is stored is abstracted away in
+ * this file; all of the other profile routines build, access, and
+ * modify the tree via the accessor functions found in this file.
+ *
+ * Each node may represent either a relation or a section header.
+ * 
+ * A section header must have its value field set to 0, and may a one
+ * or more child nodes, pointed to by first_child.
+ * 
+ * A relation has as its value a pointer to allocated memory
+ * containing a string.  Its first_child pointer must be null.
+ *
+ */
+
+/*
+ * Free a node, and any children
+ */
+void profile_free_node(struct profile_node *node)
+{
+	struct profile_node *child, *next;
+
+	if (node->magic != PROF_MAGIC_NODE)
+		return;
+	
+	if (node->name)
+		free(node->name);
+	if (node->value)
+		free(node->value);
+
+	for (child=node->first_child; child; child = next) {
+		next = child->next;
+		profile_free_node(child);
+	}
+	node->magic = 0;
+	
+	free(node);
+}
+
+/*
+ * Create a node
+ */
+errcode_t profile_create_node(const char *name, const char *value,
+			      struct profile_node **ret_node)
+{
+	struct profile_node *new;
+
+	new = malloc(sizeof(struct profile_node));
+	if (!new)
+		return ENOMEM;
+	memset(new, 0, sizeof(struct profile_node));
+	new->name = strdup(name);
+	if (new->name == 0) {
+	    profile_free_node(new);
+	    return ENOMEM;
+	}
+	if (value) {
+		new->value = strdup(value);
+		if (new->value == 0) {
+		    profile_free_node(new);
+		    return ENOMEM;
+		}
+	}
+	new->magic = PROF_MAGIC_NODE;
+
+	*ret_node = new;
+	return 0;
+}
+
+/*
+ * This function verifies that all of the representation invarients of
+ * the profile are true.  If not, we have a programming bug somewhere,
+ * probably in this file.
+ */
+
+/*
+ * Add a node to a particular section
+ */
+errcode_t profile_add_node(struct profile_node *section, const char *name,
+			   const char *value, struct profile_node **ret_node)
+{
+	errcode_t retval;
+	struct profile_node *p, *last, *new;
+
+	CHECK_MAGIC(section);
+
+	if (section->value)
+		return PROF_ADD_NOT_SECTION;
+
+	/*
+	 * Find the place to insert the new node.  We look for the
+	 * place *after* the last match of the node name, since 
+	 * order matters.
+	 */
+	for (p=section->first_child, last = 0; p; last = p, p = p->next) {
+		int cmp;
+		cmp = strcmp(p->name, name);
+		if (cmp > 0)
+			break;
+	}
+	retval = profile_create_node(name, value, &new);
+	if (retval)
+		return retval;
+	new->group_level = section->group_level+1;
+	new->deleted = 0;
+	new->parent = section;
+	new->prev = last;
+	new->next = p;
+	if (p)
+		p->prev = new;
+	if (last)
+		last->next = new;
+	else
+		section->first_child = new;
+	if (ret_node)
+		*ret_node = new;
+	return 0;
+}
+
+/*
+ * Iterate through the section, returning the nodes which match
+ * the given name.  If name is NULL, then interate through all the
+ * nodes in the section.  If section_flag is non-zero, only return the
+ * section which matches the name; don't return relations.  If value
+ * is non-NULL, then only return relations which match the requested
+ * value.  (The value argument is ignored if section_flag is non-zero.)
+ * 
+ * The first time this routine is called, the state pointer must be
+ * null.  When this profile_find_node_relation() returns, if the state
+ * pointer is non-NULL, then this routine should be called again.
+ * (This won't happen if section_flag is non-zero, obviously.)
+ *
+ */
+errcode_t profile_find_node(struct profile_node *section, const char *name,
+			    const char *value, int section_flag, void **state,
+			    struct profile_node **node)
+{
+	struct profile_node *p;
+
+	CHECK_MAGIC(section);
+	p = *state;
+	if (p) {
+		CHECK_MAGIC(p);
+	} else
+		p = section->first_child;
+	
+	for (; p; p = p->next) {
+		if (name && (strcmp(p->name, name)))
+			continue;
+		if (section_flag) {
+			if (p->value)
+				continue;
+		} else {
+			if (!p->value)
+				continue;
+			if (value && (strcmp(p->value, value)))
+				continue;
+		}
+		if (p->deleted)
+		    continue;
+		/* A match! */
+		if (node)
+			*node = p;
+		break;
+	}
+	if (p == 0) {
+		*state = 0;
+		return section_flag ? PROF_NO_SECTION : PROF_NO_RELATION;
+	}
+	/*
+	 * OK, we've found one match; now let's try to find another
+	 * one.  This way, if we return a non-zero state pointer,
+	 * there's guaranteed to be another match that's returned.
+	 */
+	for (p = p->next; p; p = p->next) {
+		if (name && (strcmp(p->name, name)))
+			continue;
+		if (section_flag) {
+			if (p->value)
+				continue;
+		} else {
+			if (!p->value)
+				continue;
+			if (value && (strcmp(p->value, value)))
+				continue;
+		}
+		/* A match! */
+		break;
+	}
+	*state = p;
+	return 0;
+}
+
+/*
+ * This is a general-purpose iterator for returning all nodes that
+ * match the specified name array.  
+ */
+struct profile_iterator {
+	prf_magic_t		magic;
+	profile_t		profile;
+	int			flags;
+	const char 		*const *names;
+	const char		*name;
+	prf_file_t		file;
+	int			file_serial;
+	int			done_idx;
+	struct profile_node 	*node;
+	int			num;
+};
+
+errcode_t 
+profile_iterator_create(profile_t profile, const char *const *names, int flags,
+			void **ret_iter)
+{
+	struct profile_iterator *iter;
+	int	done_idx = 0;
+
+	if (profile == 0)
+		return PROF_NO_PROFILE;
+	if (profile->magic != PROF_MAGIC_PROFILE)
+		return PROF_MAGIC_PROFILE;
+	if (!names)
+		return PROF_BAD_NAMESET;
+	if (!(flags & PROFILE_ITER_LIST_SECTION)) {
+		if (!names[0])
+			return PROF_BAD_NAMESET;
+		done_idx = 1;
+	}
+
+	if ((iter = malloc(sizeof(struct profile_iterator))) == NULL)
+		return ENOMEM;
+
+	iter->magic = PROF_MAGIC_ITERATOR;
+	iter->profile = profile;
+	iter->names = names;
+	iter->flags = flags;
+	iter->file = profile->first_file;
+	iter->done_idx = done_idx;
+	iter->node = 0;
+	iter->num = 0;
+	*ret_iter = iter;
+	return 0;
+}
+
+void profile_iterator_free(void **iter_p)
+{
+	struct profile_iterator *iter;
+
+	if (!iter_p)
+		return;
+	iter = *iter_p;
+	if (!iter || iter->magic != PROF_MAGIC_ITERATOR)
+		return;
+	free(iter);
+	*iter_p = 0;
+}
+
+/*
+ * Note: the returned character strings in ret_name and ret_value
+ * points to the stored character string in the parse string.  Before
+ * this string value is returned to a calling application
+ * (profile_node_iterator is not an exported interface), it should be
+ * strdup()'ed.
+ */
+errcode_t profile_node_iterator(void **iter_p, struct profile_node **ret_node,
+				char **ret_name, char **ret_value)
+{
+	struct profile_iterator 	*iter = *iter_p;
+	struct profile_node 		*section, *p;
+	const char			*const *cpp;
+	errcode_t			retval;
+	int				skip_num = 0;
+
+	if (!iter || iter->magic != PROF_MAGIC_ITERATOR)
+		return PROF_MAGIC_ITERATOR;
+	if (iter->file && iter->file->magic != PROF_MAGIC_FILE)
+	    return PROF_MAGIC_FILE;
+	/*
+	 * If the file has changed, then the node pointer is invalid,
+	 * so we'll have search the file again looking for it.
+	 */
+	if (iter->node && (iter->file && 
+			   iter->file->upd_serial != iter->file_serial)) {
+		iter->flags &= ~PROFILE_ITER_FINAL_SEEN;
+		skip_num = iter->num;
+		iter->node = 0;
+	}
+	if (iter->node && iter->node->magic != PROF_MAGIC_NODE) {
+	    return PROF_MAGIC_NODE;
+	}
+get_new_file:
+	if (iter->node == 0) {
+		if (iter->file == 0 ||
+		    (iter->flags & PROFILE_ITER_FINAL_SEEN)) {
+			profile_iterator_free(iter_p);
+			if (ret_node)
+				*ret_node = 0;
+			if (ret_name)
+				*ret_name = 0;
+			if (ret_value)
+				*ret_value =0;
+			return 0;
+		}
+		if ((retval = profile_update_file(iter->file))) {
+		    if (retval == ENOENT || retval == EACCES) {
+			/* XXX memory leak? */
+			iter->file = iter->file->next;
+			skip_num = 0;
+			retval = 0;
+			goto get_new_file;
+		    } else {
+			profile_iterator_free(iter_p);
+			return retval;
+		    }
+		}
+		iter->file_serial = iter->file->upd_serial;
+		/*
+		 * Find the section to list if we are a LIST_SECTION,
+		 * or find the containing section if not.
+		 */
+		section = iter->file->root;
+		for (cpp = iter->names; cpp[iter->done_idx]; cpp++) {
+			for (p=section->first_child; p; p = p->next) {
+				if (!strcmp(p->name, *cpp) && !p->value)
+					break;
+			}
+			if (!p) {
+				section = 0;
+				break;
+			}
+			section = p;
+			if (p->final)
+				iter->flags |= PROFILE_ITER_FINAL_SEEN;
+		}
+		if (!section) {
+			iter->file = iter->file->next;
+			skip_num = 0;
+			goto get_new_file;
+		}
+		iter->name = *cpp;
+		iter->node = section->first_child;
+	}
+	/*
+	 * OK, now we know iter->node is set up correctly.  Let's do
+	 * the search.
+	 */
+	for (p = iter->node; p; p = p->next) {
+		if (iter->name && strcmp(p->name, iter->name))
+			continue;
+		if ((iter->flags & PROFILE_ITER_SECTIONS_ONLY) &&
+		    p->value)
+			continue;
+		if ((iter->flags & PROFILE_ITER_RELATIONS_ONLY) &&
+		    !p->value)
+			continue;
+		if (skip_num > 0) {
+			skip_num--;
+			continue;
+		}
+		if (p->deleted)
+			continue;
+		break;
+	}
+	iter->num++;
+	if (!p) {
+		iter->file = iter->file->next;
+		iter->node = 0;
+		skip_num = 0;
+		goto get_new_file;
+	}
+	if ((iter->node = p->next) == NULL)
+		iter->file = iter->file->next;
+	if (ret_node)
+		*ret_node = p;
+	if (ret_name)
+		*ret_name = p->name;
+	if (ret_value)
+		*ret_value = p->value;
+	return 0;
+}
+
+
+
+/*
+ * This function only gets the first value from the file; it is a
+ * helper function for profile_get_string, profile_get_integer, etc.
+ */
+errcode_t profile_get_value(profile_t profile, const char *names[],
+			    const char **ret_value)
+{
+	errcode_t		retval;
+	void			*state;
+	char			*value;
+
+	if ((retval = profile_iterator_create(profile, names,
+					      PROFILE_ITER_RELATIONS_ONLY,
+					      &state)))
+		return retval;
+
+	if ((retval = profile_node_iterator(&state, 0, 0, &value)))
+		goto cleanup;
+
+	if (value)
+		*ret_value = value;
+	else
+		retval = PROF_NO_RELATION;
+	
+cleanup:
+	profile_iterator_free(&state);
+	return retval;
+}
+
+errcode_t 
+profile_get_string(profile_t profile, const char *names[], const char *def_val,
+		   char **ret_string)
+{
+	const char	*value;
+	errcode_t	retval;
+
+	if (profile) {
+		retval = profile_get_value(profile, names, &value);
+		if (retval == PROF_NO_SECTION || retval == PROF_NO_RELATION)
+			value = def_val;
+		else if (retval)
+			return retval;
+	} else
+		value = def_val;
+    
+	if (value) {
+		*ret_string = malloc(strlen(value)+1);
+		if (*ret_string == 0)
+			return ENOMEM;
+		strcpy(*ret_string, value);
+	} else
+		*ret_string = 0;
+	return 0;
+}
+errcode_t 
+profile_get_integer(profile_t profile, const char *names[], int def_val, int *ret_int)
+{
+	const char	*value;
+	errcode_t	retval;
+	char            *end_value;
+	long		ret_long;
+
+	*ret_int = def_val;
+	if (profile == 0)
+		return 0;
+
+	retval = profile_get_value(profile, names, &value);
+	if (retval == PROF_NO_SECTION || retval == PROF_NO_RELATION) {
+		*ret_int = def_val;
+		return 0;
+	} else if (retval)
+		return retval;
+
+	if (value[0] == 0)
+	    return PROF_BAD_INTEGER;
+	errno = 0;
+	ret_long = strtol (value, &end_value, 10);
+
+	if ((ret_long == LONG_MIN || ret_long == LONG_MAX) && errno != 0)
+	    return PROF_BAD_INTEGER;
+	if ((long) (int) ret_long != ret_long)
+	    return PROF_BAD_INTEGER;
+	if (end_value != value + strlen (value))
+	    return PROF_BAD_INTEGER;
+	
+   
+	*ret_int = ret_long;
+	return 0;
+}
+
+errcode_t 
+profile_get_uint(profile_t profile, const char *names[], unsigned int def_val, 
+		 unsigned int *ret_int)
+{
+	const char	*value;
+	errcode_t	retval;
+	char            *end_value;
+	unsigned long	ret_long;
+
+	*ret_int = def_val;
+	if (profile == 0)
+		return 0;
+
+	retval = profile_get_value(profile, names, &value);
+	if (retval == PROF_NO_SECTION || retval == PROF_NO_RELATION) {
+		*ret_int = def_val;
+		return 0;
+	} else if (retval)
+		return retval;
+
+	if (value[0] == 0)
+	    return PROF_BAD_INTEGER;
+	errno = 0;
+	ret_long = strtoul (value, &end_value, 10);
+
+	if ((ret_long == ULONG_MAX) && errno != 0)
+	    return PROF_BAD_INTEGER;
+	if ((unsigned long) (unsigned int) ret_long != ret_long)
+	    return PROF_BAD_INTEGER;
+	if (end_value != value + strlen (value))
+	    return PROF_BAD_INTEGER;
+	
+	*ret_int = ret_long;
+	return 0;
+}
+
+/* XXX: Ugly hack, replace */
+#define ULLONG_MAX	(unsigned long long)(-1LL)
+
+errcode_t 
+profile_get_bytesize(profile_t profile, const char *names[], 
+		 unsigned long long def_val, unsigned long long *retval)
+{
+	const char	*value;
+	errcode_t	error;
+	char            *end_value;
+	unsigned long long ret_long;
+
+	*retval = def_val;
+	if (profile == 0)
+		return 0;
+
+	error = profile_get_value(profile, names, &value);
+	if (error == PROF_NO_SECTION || error == PROF_NO_RELATION) 
+		return 0;
+	else if (error)
+		return error;
+
+	if (value[0] == 0)
+	    return PROF_BAD_INTEGER;
+
+	errno = 0;
+	ret_long = strtoull (value, &end_value, 10);
+	if ((ret_long == ULLONG_MAX) && errno != 0)
+	    return PROF_BAD_INTEGER;
+
+	end_value=skip_over_blanks(end_value);
+
+	switch(*end_value)
+	{
+		case 'T':
+		case 't':
+			ret_long*=1024ULL*1024*1024*1024;
+			break;
+		case 'g':
+		case 'G':
+			ret_long*=1024ULL*1024*1024;
+			break;
+		case 'm':
+		case 'M':
+			ret_long*=1024ULL*1024;
+			break;
+		case 'k':
+		case 'K':
+			ret_long*=1024;
+			break;
+		case '\0':
+		case 'b':
+		case 'B':
+			break;
+		default:
+			return PROF_BAD_INTEGER;
+	}
+
+	*retval = ret_long;
+	return 0;
+}
+
+
+errcode_t 
+profile_iterator(void **iter_p, char **ret_name, char **ret_value)
+{
+	char *name, *value;
+	errcode_t	retval;
+	
+	retval = profile_node_iterator(iter_p, 0, &name, &value);
+	if (retval)
+		return retval;
+
+	if (ret_name) {
+		if (name) {
+			*ret_name = malloc(strlen(name)+1);
+			if (!*ret_name)
+				return ENOMEM;
+			strcpy(*ret_name, name);
+		} else
+			*ret_name = 0;
+	}
+	if (ret_value) {
+		if (value) {
+			*ret_value = malloc(strlen(value)+1);
+			if (!*ret_value) {
+				if (ret_name) {
+					free(*ret_name);
+					*ret_name = 0;
+				}
+				return ENOMEM;
+			}
+			strcpy(*ret_value, value);
+		} else
+			*ret_value = 0;
+	}
+	return 0;
+}
+
diff --git a/mkfs.ocfs2/profile.h b/mkfs.ocfs2/profile.h
new file mode 100644
index 0000000..1ff23d9
--- /dev/null
+++ b/mkfs.ocfs2/profile.h
@@ -0,0 +1,70 @@
+/*
+ * profile.h
+ *
+ * Copyright (C) 2005 by Theodore Ts'o.
+ *
+ * %Begin-Header%
+ * This file may be redistributed under the terms of the GNU Public
+ * License.
+ * %End-Header%
+ * 
+ */
+
+#ifndef _PROFILE_H
+#define _PROFILE_H
+
+typedef struct _profile_t *profile_t;
+
+typedef void (*profile_syntax_err_cb_t)(const char *file, long err, 
+					int line_num);
+
+/*
+ * Used by the profile iterator in prof_get.c
+ */
+#define PROFILE_ITER_LIST_SECTION	0x0001
+#define PROFILE_ITER_SECTIONS_ONLY	0x0002
+#define PROFILE_ITER_RELATIONS_ONLY	0x0004
+
+#ifdef __cplusplus
+extern "C" {
+#endif /* __cplusplus */
+
+long profile_init
+	(const char * *files, profile_t *ret_profile);
+
+void profile_release
+	(profile_t profile);
+
+long profile_set_default
+	(profile_t profile, const char *def_string);
+
+long profile_get_string
+	(profile_t profile, const char *names[], const char *def_val,
+			char **ret_string);
+long profile_get_integer
+	(profile_t profile, const char *names[], int def_val,
+			int *ret_default);
+long profile_get_bytesize
+	(profile_t profile, const char *names[], unsigned long long def_val,
+	 unsigned long long *retval);
+long profile_get_uint
+	(profile_t profile, const char *names[], unsigned int def_val, 
+		unsigned int *ret_int);
+
+long profile_iterator_create
+	(profile_t profile, const char *const *names,
+		   int flags, void **ret_iter);
+
+void profile_iterator_free
+	(void **iter_p);
+	
+long profile_iterator
+	(void	**iter_p, char **ret_name, char **ret_value);
+
+profile_syntax_err_cb_t profile_set_syntax_err_cb(profile_syntax_err_cb_t hook);
+
+#ifdef __cplusplus
+}
+#endif /* __cplusplus */
+
+#endif
