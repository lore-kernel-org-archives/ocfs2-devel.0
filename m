From: Rusty Lynch <rusty@linux.co.intel.com>
Date: Thu Mar 25 17:02:50 2004
Subject: [Ocfs2-devel] Uitlity for adjusting debug_[level|context]
Message-ID: <20040325230203.GA21722@penguin.co.intel.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

After working on ocfs2 for a little while now, I find myself still
having to look at ocfs.h every time I want to adjust the log level
and/or context.

I started getting tired of doing this so I wrote an embarrising not
so little utility for adjusting the log level and context for ocfs.
Just in case someone else finds this useful, I attached the source
file to this email.

Here is the kind of stuff it can do...

[root@penguin oracle]# ocfslogctl
Log Level:    ERROR TRACE ENTRY EXIT TIMING STACK PRINTK MALLOC 
Log Context:  INODE
[root@penguin oracle]# ocfslogctl --help
Usage: ocfslogctl [OPTION...]
Control OCFS Log Level

      --clear-all            Clear all levels and contexts
      --show                 Print the current log level and context

 Log level options
      --entry                Turn on entry level messages
      --error                Turn on error level messages
      --exit                 Turn on exit level messages
      --malloc               Turn on malloc level messages
      --printk               Turn on printk level messages
      --set-all-levels       Turn on messages for all levels
      --stack                Turn on stack level messages
      --timing               Turn on timing level messages
      --trace                Turn on trace level messages

 Log context options
      --alloc                Enable messages from alloc.c
      --bitmap               Enable messages from bitmap.c
      --dcache               Enable messages from dcache.c
      --dir                  Enable messages from dir.c
      --dlm                  Enable messages from dlm.c
      --extmap               Enable messages from extmap.c
      --file                 Enable messages from file.c
      --hash                 Enable messages from hash.c
      --heartbeat            Enable messages from heartbeat.c
      --inode                Enable messages from inode.c
      --io                   Enable messages from io.c
      --ioctl                Enable messages from ioctl.c
      --journal              Enable messages from journal.c
      --namei                Enable messages from namei.c
      --nm                   Enable messges from nm.c
      --oin                  Enable messages from oin.c
      --osb                  Enable messages from osb.c
      --proc                 Enable messages from proc.c
      --sem                  Enable messages from sem.c
      --set-all-contexts     Enable messages from all contexts
      --super                Enable messages from super.c
      --symlink              Enable messages from symlink.c
      --sysfile              Enable messages from sysfile.c
      --util                 Enable message from util.c
      --volcfg               Enable messages from volcfg.c
      --vote                 Enable messages from vote.c

  -?, --help                 Give this help list
      --usage                Give a short usage message
  -V, --version              Print program version

Report bugs to </dev/null>.
[root@penguin oracle]# ocfslogctl --trace --inode
[root@penguin oracle]# ocfslogctl --show
Log Level:    TRACE 
Log Context:  INODE
[root@penguin oracle]# dmesg -c
(20231) TRACE: ocfs_put_inode() put_inode: count=3
(20231) TRACE: ocfs_put_inode() put_inode: count=3
(20231) TRACE: ocfs_put_inode() put_inode: count=3
(20231) TRACE: ocfs_put_inode() put_inode: count=3
(20231) TRACE: ocfs_put_inode() put_inode: count=3
(20231) TRACE: ocfs_put_inode() put_inode: count=3
(20231) TRACE: ocfs_put_inode() put_inode: count=3
(20231) TRACE: ocfs_put_inode() put_inode: count=3
[root@penguin oracle]# touch somenewfile
[root@penguin oracle]# dmesg -c
(21693) TRACE: ocfs_put_inode() put_inode: count=3
(21693) TRACE: ocfs_put_inode() put_inode: count=3
(21693) TRACE: ocfs_put_inode() put_inode: count=3
(21693) TRACE: ocfs_put_inode() put_inode: count=3
(21693) TRACE: ocfs_put_inode() put_inode: count=3
(21693) TRACE: ocfs_put_inode() put_inode: count=3
(21693) TRACE: ocfs_put_inode() put_inode: count=3
(21693) TRACE: ocfs_put_inode() put_inode: count=3
lockres: lockid=2416640.0, this=1, master=1, locktype=8, flags=40005001, ronode=1, romap=00000000
new_lock_function: set lockid=2416640.0, locktype=8->8, master=1->1
(21693) TRACE: ocfs_put_inode() put_inode: count=3
(21693) TRACE: ocfs_put_inode() put_inode: count=3
(21693) TRACE: ocfs_put_inode() put_inode: count=3
(21693) TRACE: ocfs_put_inode() put_inode: count=3
(21693) TRACE: ocfs_put_inode() put_inode: count=3
(21693) TRACE: ocfs_put_inode() put_inode: count=3
(21693) TRACE: ocfs_put_inode() put_inode: count=3
(21693) TRACE: ocfs_put_inode() put_inode: count=3
(21693) TRACE: ocfs_populate_inode() offset = 0.2419712, ino = 1246, create_ino = true
(21693) TRACE: ocfs_put_inode() put_inode: count=3
(21693) TRACE: ocfs_put_inode() put_inode: count=3
(21693) TRACE: ocfs_put_inode() put_inode: count=3
(21693) TRACE: ocfs_put_inode() put_inode: count=3
(21693) TRACE: ocfs_put_inode() put_inode: count=3
(21693) TRACE: ocfs_put_inode() put_inode: count=3
(21693) TRACE: ocfs_put_inode() put_inode: count=3
(21693) TRACE: ocfs_put_inode() put_inode: count=3
(21693) TRACE: ocfs_put_inode() put_inode: count=3
(21693) TRACE: ocfs_put_inode() put_inode: count=3
lockres: lockid=2419712.0, this=1, master=1, locktype=8, flags=40004010, ronode=-1, romap=00000000
new_lock_function: set lockid=2419712.0, locktype=8->8, master=1->1

-------------- next part --------------
#include <argp.h>
#include <fcntl.h>
#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <sys/mman.h>
#include <sys/types.h>
#include <sys/stat.h>

/*
 * The log level and context defines are pulled directly out of
 * ocfs.h, and are required to be syncronized with any changes
 * in the ocfs code base.
 */

/* Log Level */
#define OCFS_DEBUG_LEVEL_ERROR         0x00000001
#define OCFS_DEBUG_LEVEL_TRACE         0x00000002
#define OCFS_DEBUG_LEVEL_ENTRY         0x00000010
#define OCFS_DEBUG_LEVEL_EXIT          0x00000020
#define OCFS_DEBUG_LEVEL_TIMING        0x00000100
#define OCFS_DEBUG_LEVEL_STACK         0x00000200
#define OCFS_DEBUG_LEVEL_PRINTK        0x00001000
#define OCFS_DEBUG_LEVEL_MALLOC        0x00002000

/* Log Context */
#define OCFS_DEBUG_CONTEXT_ALLOC       0x00000001	/* alloc.c    */
#define OCFS_DEBUG_CONTEXT_DIR         0x00000002	/* dir.c      */
#define OCFS_DEBUG_CONTEXT_EXTMAP      0x00000004	/* extmap.c   */
#define OCFS_DEBUG_CONTEXT_HEARTBEAT   0x00000008	/* hearbeat.c */
#define OCFS_DEBUG_CONTEXT_IOCTL       0x00000010	/* ioctl.c    */
#define OCFS_DEBUG_CONTEXT_NM          0x00000020	/* nm.c       */
#define OCFS_DEBUG_CONTEXT_PROC        0x00000040	/* proc.c     */
#define OCFS_DEBUG_CONTEXT_SYMLINK     0x00000080	/* symlink.c  */
#define OCFS_DEBUG_CONTEXT_BITMAP      0x00000100	/* bitmap.c   */
#define OCFS_DEBUG_CONTEXT_FILE        0x00000200	/* file.c     */
#define OCFS_DEBUG_CONTEXT_INODE       0x00000400	/* inode.c    */
#define OCFS_DEBUG_CONTEXT_JOURNAL     0x00000800	/* journal.c  */
#define OCFS_DEBUG_CONTEXT_OIN         0x00001000	/* oin.c      */
#define OCFS_DEBUG_CONTEXT_SEM         0x00002000	/* sem.c      */
#define OCFS_DEBUG_CONTEXT_SYSFILE     0x00004000	/* sysfile.c  */
#define OCFS_DEBUG_CONTEXT_VOLCFG      0x00008000	/* volcfg.c   */
#define OCFS_DEBUG_CONTEXT_DCACHE      0x00010000	/* dcache.c   */
#define OCFS_DEBUG_CONTEXT_DLM         0x00020000	/* dlm.c      */
#define OCFS_DEBUG_CONTEXT_HASH        0x00040000	/* hash.c     */
#define OCFS_DEBUG_CONTEXT_IO          0x00080000	/* io.c       */
#define OCFS_DEBUG_CONTEXT_NAMEI       0x00100000	/* namei.c    */
#define OCFS_DEBUG_CONTEXT_OSB         0x00200000	/* osb.c      */
#define OCFS_DEBUG_CONTEXT_SUPER       0x00400000	/* super.c    */
#define OCFS_DEBUG_CONTEXT_UTIL        0x00800000	/* util.c     */
#define OCFS_DEBUG_CONTEXT_VOTE        0x01000000	/* vote.c     */

#define TRACE(fmt, arg...)                        \
        do {                                      \
                if (args.noisy)                   \
                        printf(fmt "\n", ## arg); \
} while (0)

const char *argp_program_version     = "0.1";
const char *argp_program_bug_address = "</dev/null>";
static char doc[]                    = "Control OCFS Log Level";
static struct argp_option options[] = {
	{"show",  201, 0, 0, "Print the current log level and context"},
	{"clear-all", 301, 0, 0, "Clear all levels and contexts"},

	{0, 0, 0, 0, "Log level options"},
	{"set-all-levels",    203, 0, 0, "Turn on messages for all levels"},
	{"error",             204, 0, 0, "Turn on error level messages"},
	{"trace",             205, 0, 0, "Turn on trace level messages"},
	{"entry",             206, 0, 0, "Turn on entry level messages"},
	{"exit",              207, 0, 0, "Turn on exit level messages"},
	{"timing",            208, 0, 0, "Turn on timing level messages"},
	{"stack",             209, 0, 0, "Turn on stack level messages"},
	{"printk",            210, 0, 0, "Turn on printk level messages"},
	{"malloc",            211, 0, 0, "Turn on malloc level messages"},

	{0, 0, 0, 0, "Log context options"},
	{"set-all-contexts",  202, 0, 0, "Enable messages from all contexts"},
	{"alloc",             212, 0, 0, "Enable messages from alloc.c"},
	{"dir",               213, 0, 0, "Enable messages from dir.c"},
	{"extmap",            214, 0, 0, "Enable messages from extmap.c"},	
	{"heartbeat",         215, 0, 0, "Enable messages from heartbeat.c"},
	{"ioctl",             216, 0, 0, "Enable messages from ioctl.c"},
	{"nm",                217, 0, 0, "Enable messges from nm.c"},
	{"proc",              218, 0, 0, "Enable messages from proc.c"},
	{"symlink",           219, 0, 0, "Enable messages from symlink.c"},
	{"bitmap",            220, 0, 0, "Enable messages from bitmap.c"},
	{"file",              221, 0, 0, "Enable messages from file.c"},
	{"inode",             222, 0, 0, "Enable messages from inode.c"},
	{"journal",           223, 0, 0, "Enable messages from journal.c"},
	{"oin",               224, 0, 0, "Enable messages from oin.c"},
	{"sem",               225, 0, 0, "Enable messages from sem.c"},	 
	{"sysfile",           226, 0, 0, "Enable messages from sysfile.c"},
	{"volcfg",            227, 0, 0, "Enable messages from volcfg.c"},
	{"dcache",            228, 0, 0, "Enable messages from dcache.c"},
	{"dlm",               229, 0, 0, "Enable messages from dlm.c"},
	{"hash",              230, 0, 0, "Enable messages from hash.c"},
	{"io",                231, 0, 0, "Enable messages from io.c"},
	{"namei",             232, 0, 0, "Enable messages from namei.c"},
	{"osb",               233, 0, 0, "Enable messages from osb.c"},
	{"super",             234, 0, 0, "Enable messages from super.c"},
	{"util",              235, 0, 0, "Enable message from util.c"},
	{"vote",              236, 0, 0, "Enable messages from vote.c"},
	{ 0 }
};

struct args
{
	int show;
	int set_all_levels;
	int set_all_contexts;
	int clear_all;
	int error;
	int trace;
	int entry;
	int exit;
	int timing;
	int stack;
	int printk;
	int malloc;
	int alloc;
	int dir;
	int extmap;
	int heartbeat;
	int ioctl;
	int nm;
	int proc;
	int symlink;
	int bitmap;
	int file;
	int inode;
	int journal;
	int oin;
	int sem;
	int sysfile;
	int volcfg;
	int dcache;
	int dlm;
	int hash;
	int io;
	int namei;
	int osb;
	int super;
	int util;
	int vote;	
};

static error_t parse_opt (int key, char *arg, struct argp_state *state)
{
	struct args *args = state->input;
     
	switch (key) {
	case 201:
		args->show = 1;
		break;
	case 202:
		args->set_all_contexts = 1;
		break;
	case 203:
		args->set_all_levels = 1;
		break;
	case 204:
		args->error = 1;
		break;
	case 205:
		args->trace = 1;
		break;
	case 206:		
		args->entry = 1;
		break;
	case 207:
		args->exit = 1;
		break;
	case 208:
		args->timing = 1;
		break;
	case 209:
		args->stack = 1;
		break;
	case 210:
		args->printk = 1;
		break;
	case 211:
		args->malloc = 1;
		break;
	case 212:
		args->alloc = 1;
		break;
	case 213:
		args->dir = 1;
		break;
	case 214:
		args->extmap = 1;
		break;
	case 215:
		args->heartbeat = 1;
		break;
	case 216:
		args->ioctl = 1;
		break;
	case 217:
		args->nm = 1;
		break;
	case 218:
		args->proc = 1;
		break;
	case 219:
		args->symlink = 1;
		break;
	case 220:
		args->bitmap = 1;
		break;
	case 221:
		args->file = 1;
		break;
	case 222:
		args->inode = 1;
		break;
	case 223:
		args->journal = 1;
		break;
	case 224:
		args->oin = 1;
		break;
	case 225:
		args->sem = 1;
		break;
	case 226:
		args->sysfile = 1;
		break;
	case 227:
		args->volcfg = 1;
		break;
	case 228:
		args->dcache = 1;
		break;
	case 229:
		args->dlm = 1;
		break;
	case 230:
		args->hash = 1;
		break;
	case 231:
		args->io = 1;
		break;
	case 232:
		args->namei = 1;
		break;
	case 233:
		args->osb = 1;
		break;
	case 234:
		args->super = 1;
		break;
	case 235:
		args->util = 1;
		break;
	case 236:
		args->vote = 1;
		break;
	case 301:
		args->clear_all = 1;
		break;
	default:
		return ARGP_ERR_UNKNOWN;
	}
	return 0;
}

static struct argp argp = { 
	.options = options, 
	.parser = parse_opt, 
	.args_doc = 0, 
	.doc = doc
};

int set_debug_level(int level)
{	
	int fd;
	char str[] = "0x00000000";

	fd = open("/proc/sys/kernel/ocfs2/debug_level", O_WRONLY);
	if (-1 == fd) {
		perror("open");
		return -1;
	}
	
	snprintf(str, sizeof(str), "0x%08x", level);
	if (-1 == write(fd, str, sizeof(str))) {
		perror("write");
		return -1;
	}

	close(fd);
	return 0;
}

int set_debug_context(int context)
{
	int fd;
	char str[] = "0x00000000";

	fd = open("/proc/sys/kernel/ocfs2/debug_context", O_WRONLY);
	if (-1 == fd) {
		perror("open");
		return -1;
	}
	
	snprintf(str, sizeof(str), "0x%08x", context);
	if (-1 == write(fd, str, sizeof(str))) {
		perror("write");
		return -1;
	}

	close(fd);
	return 0;
}

void show_debug_level(void) 
{
	int fd, log_level;
	char str[20];

	fd = open("/proc/sys/kernel/ocfs2/debug_level", O_RDONLY);
	if (-1 == fd) {
		perror("open");
		return;
	}
	

	if (-1 == read(fd, str, 20)) {
		perror("write");
		return;
	}
	sscanf(str, "%i", &log_level);
	printf("Log Level:    ");
	if (log_level & OCFS_DEBUG_LEVEL_ERROR)
		printf("ERROR ");
	if (log_level & OCFS_DEBUG_LEVEL_TRACE)
		printf("TRACE ");
	if (log_level & OCFS_DEBUG_LEVEL_ENTRY)
		printf("ENTRY ");
	if (log_level & OCFS_DEBUG_LEVEL_EXIT)
		printf("EXIT ");
	if (log_level & OCFS_DEBUG_LEVEL_TIMING)
		printf("TIMING ");
	if (log_level & OCFS_DEBUG_LEVEL_STACK)
		printf("STACK ");
	if (log_level & OCFS_DEBUG_LEVEL_PRINTK)
		printf("PRINTK ");
	if (log_level & OCFS_DEBUG_LEVEL_MALLOC)
		printf("MALLOC ");
	printf("\n");
	
	close(fd);
	
}

void show_debug_context(void) 
{
	int fd, log_context;
	char str[20];

	fd = open("/proc/sys/kernel/ocfs2/debug_context", O_RDONLY);
	if (-1 == fd) {
		perror("open");
		return;
	}
	

	if (-1 == read(fd, str, 20)) {
		perror("write");
		return;
	}
	sscanf(str, "%i", &log_context);
	printf("Log Context: ");

	if (log_context & OCFS_DEBUG_CONTEXT_ALLOC)
		printf(" ALLOC");
	if (log_context & OCFS_DEBUG_CONTEXT_DIR)
		printf(" DIR");
	if (log_context & OCFS_DEBUG_CONTEXT_EXTMAP)
		printf(" EXTMAP");
	if (log_context & OCFS_DEBUG_CONTEXT_HEARTBEAT)
		printf(" HEARTBEAT");
	if (log_context & OCFS_DEBUG_CONTEXT_IOCTL)
		printf(" IOCTL");
	if (log_context & OCFS_DEBUG_CONTEXT_NM)
		printf(" NM");
	if (log_context & OCFS_DEBUG_CONTEXT_PROC)
		printf(" PROC");
	if (log_context & OCFS_DEBUG_CONTEXT_SYMLINK)
		printf(" SYMLINK");
	if (log_context & OCFS_DEBUG_CONTEXT_BITMAP)
		printf(" BITMAP");
	if (log_context & OCFS_DEBUG_CONTEXT_FILE)
		printf(" FILE");
	if (log_context & OCFS_DEBUG_CONTEXT_INODE)
		printf(" INODE");
	if (log_context & OCFS_DEBUG_CONTEXT_JOURNAL)
		printf(" JOURNAL");
	if (log_context & OCFS_DEBUG_CONTEXT_OIN)
		printf(" OIN");
	if (log_context & OCFS_DEBUG_CONTEXT_SEM)
		printf(" SEM");
	if (log_context & OCFS_DEBUG_CONTEXT_SYSFILE)
		printf(" SYSFILE");
	if (log_context & OCFS_DEBUG_CONTEXT_VOLCFG)
		printf(" VOLCFG");
	if (log_context & OCFS_DEBUG_CONTEXT_DCACHE)
		printf(" DCACHE");
	if (log_context & OCFS_DEBUG_CONTEXT_DLM)
		printf(" DLM");
	if (log_context & OCFS_DEBUG_CONTEXT_HASH)
		printf(" HASH");
	if (log_context & OCFS_DEBUG_CONTEXT_IO)
		printf(" IO");
	if (log_context & OCFS_DEBUG_CONTEXT_NAMEI)
		printf(" NAMEI");
	if (log_context & OCFS_DEBUG_CONTEXT_OSB)
		printf(" OSB");
	if (log_context & OCFS_DEBUG_CONTEXT_SUPER)
		printf(" SUPER");
	if (log_context & OCFS_DEBUG_CONTEXT_UTIL)
		printf(" UTIL");
	if (log_context & OCFS_DEBUG_CONTEXT_VOTE)
		printf(" VOTE");
	printf("\n");
	close(fd);
	
}

int main(int argc, char *argv[])
{
	int debug_level = 0, debug_context = 0;
	struct args args = {};

	if (argp_parse (&argp, argc, argv, ARGP_LONG_ONLY, 0, &args)) {
		fprintf(stderr, "Invalid arguments\n");
		exit(-1);
	}

	if (argc == 1 || args.show) {
		show_debug_level();
		show_debug_context();
		exit(0);
	}
		
	/*
	 * Calculate the debug_level
	 */
	if (args.set_all_levels) {
		debug_level = 0xffffffff;
	} else {
		if (args.error) 
			debug_level |= OCFS_DEBUG_LEVEL_ERROR;
		if (args.trace)
			debug_level |= OCFS_DEBUG_LEVEL_TRACE;
		if (args.entry)
			debug_level |= OCFS_DEBUG_LEVEL_ENTRY;
		if (args.exit)
			debug_level |= OCFS_DEBUG_LEVEL_EXIT;
		if (args.timing)
			debug_level |= OCFS_DEBUG_LEVEL_TIMING;
		if (args.stack)
			debug_level |= OCFS_DEBUG_LEVEL_STACK;
		if (args.printk)
			debug_level |= OCFS_DEBUG_LEVEL_PRINTK;
		if (args.malloc)
			debug_level |= OCFS_DEBUG_LEVEL_MALLOC;
	}

	/* 
	 * calculate the debug_context
	 */
	if (args.set_all_contexts) {
		debug_context = 0xffffffff;
	} else {
		if (args.alloc)
			debug_context |= OCFS_DEBUG_CONTEXT_ALLOC;
		if (args.dir)
			debug_context |= OCFS_DEBUG_CONTEXT_DIR;
		if (args.extmap)
			debug_context |= OCFS_DEBUG_CONTEXT_EXTMAP;
		if (args.heartbeat)
			debug_context |= OCFS_DEBUG_CONTEXT_HEARTBEAT;
		if (args.ioctl)
			debug_context |= OCFS_DEBUG_CONTEXT_IOCTL;
		if (args.nm)
			debug_context |= OCFS_DEBUG_CONTEXT_NM;
		if (args.proc)
			debug_context |= OCFS_DEBUG_CONTEXT_PROC;
		if (args.symlink)
			debug_context |= OCFS_DEBUG_CONTEXT_SYMLINK;
		if (args.bitmap)
			debug_context |= OCFS_DEBUG_CONTEXT_BITMAP;
		if (args.file)
			debug_context |= OCFS_DEBUG_CONTEXT_FILE;
		if (args.inode)
			debug_context |= OCFS_DEBUG_CONTEXT_INODE;
		if (args.journal)
			debug_context |= OCFS_DEBUG_CONTEXT_JOURNAL;
		if (args.oin)
			debug_context |= OCFS_DEBUG_CONTEXT_OIN;
		if (args.sem)
			debug_context |= OCFS_DEBUG_CONTEXT_SEM;
		if (args.sysfile)
			debug_context |= OCFS_DEBUG_CONTEXT_SYSFILE;
		if (args.volcfg)
			debug_context |= OCFS_DEBUG_CONTEXT_VOLCFG;
		if (args.dcache)
			debug_context |= OCFS_DEBUG_CONTEXT_DCACHE;
		if (args.dlm)
			debug_context |= OCFS_DEBUG_CONTEXT_DLM;
		if (args.hash)
			debug_context |= OCFS_DEBUG_CONTEXT_HASH;
		if (args.io)
			debug_context |= OCFS_DEBUG_CONTEXT_IO;
		if (args.namei)
			debug_context |= OCFS_DEBUG_CONTEXT_NAMEI;
		if (args.osb)
			debug_context |= OCFS_DEBUG_CONTEXT_OSB;
		if (args.super)
			debug_context |= OCFS_DEBUG_CONTEXT_SUPER;
		if (args.util)
			debug_context |= OCFS_DEBUG_CONTEXT_UTIL;
		if (args.vote)
			debug_context |= OCFS_DEBUG_CONTEXT_VOTE;
	}
	set_debug_level(debug_level);
	set_debug_context(debug_context);

	exit (0);
}
