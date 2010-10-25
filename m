From: Tristan Ye <tristan.ye@oracle.com>
Date: Mon, 25 Oct 2010 19:09:46 +0800
Subject: [Ocfs2-devel] [PATCH 2/6] O2info: Build a main framework for o2info.
In-Reply-To: <1288004990-20076-1-git-send-email-tristan.ye@oracle.com>
References: <1288004990-20076-1-git-send-email-tristan.ye@oracle.com>
Message-ID: <1288004990-20076-3-git-send-email-tristan.ye@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

This patch tries to build main framework with necessary *.h and *.c
files being generated. it did the option parsing and initialization,
and only works for --help and --version, more operations will be
elaborated in later patches.

To be more detail: all of o2info's operations will be linked to
a task list, and executed one by one later.

Workflow of adding a new operation task for o2info(such as --volinfo)
will be like following:

1. Declare a new extern operation structure.
   extern struct o2info_operation volinfo_op;

2. Add a new option:
   static struct o2info_option volinfo_option = {
        .opt_option     = {
                .name           = "volinfo",
                .val            = 'V',
                .has_arg        = 0,
                .flag           = NULL,
        },
        .opt_help       =
                "-V|--volinfo",
        .opt_handler    = NULL,
        .opt_op         = &volinfo_op,
        .opt_private    = NULL,
};

3. Implement necessary utility func in utils.c.

4. Implement the real running codes for volinfo_op in operation.c.

Signed-off-by: Tristan Ye <tristan.ye@oracle.com>
---
 CREDITS                                   |    3 +
 Makefile                                  |    2 +-
 configure.in                              |    1 +
 debian/ocfs2-tools.install                |    2 +
 debian/ocfs2-tools.manpages               |    1 +
 o2info/.gitignore                         |    6 +
 o2info/Makefile                           |   38 +++
 o2info/o2info.1.in                        |   28 ++
 o2info/o2info.c                           |  484 +++++++++++++++++++++++++++++
 o2info/o2info.h                           |   82 +++++
 o2info/operations.c                       |   61 ++++
 o2info/utils.c                            |  109 +++++++
 o2info/utils.h                            |   30 ++
 vendor/common/ocfs2-tools.spec-generic.in |    2 +
 14 files changed, 848 insertions(+), 1 deletions(-)
 create mode 100644 o2info/.gitignore
 create mode 100644 o2info/Makefile
 create mode 100644 o2info/o2info.1.in
 create mode 100644 o2info/o2info.c
 create mode 100644 o2info/o2info.h
 create mode 100644 o2info/operations.c
 create mode 100644 o2info/utils.c
 create mode 100644 o2info/utils.h

diff --git a/CREDITS b/CREDITS
index d15ca67..042b8e1 100644
--- a/CREDITS
+++ b/CREDITS
@@ -29,6 +29,9 @@ ocfs2cdsl:
 ocfs2console:
 	Written by Manish Singh.
 
+o2info:
+	Written by Tristan Ye.
+
 ocfs2console/blkid:
 	From e2fsprogs 1.37, by Theodore Ts'o and Andreas Dilger.
 
diff --git a/Makefile b/Makefile
index 88106fb..8b71e72 100644
--- a/Makefile
+++ b/Makefile
@@ -20,7 +20,7 @@ CHKCONFIG_DEP = chkconfig
 COMPILE_PY = 1
 endif
 
-SUBDIRS = include libtools-internal libo2dlm libo2cb libocfs2 fsck.ocfs2 mkfs.ocfs2 mounted.ocfs2 tunefs.ocfs2 debugfs.ocfs2 o2cb_ctl ocfs2_hb_ctl mount.ocfs2 ocfs2_controld o2image listuuid sizetest extras fswreck patches
+SUBDIRS = include libtools-internal libo2dlm libo2cb libocfs2 fsck.ocfs2 mkfs.ocfs2 mounted.ocfs2 tunefs.ocfs2 debugfs.ocfs2 o2cb_ctl ocfs2_hb_ctl mount.ocfs2 ocfs2_controld o2image o2info listuuid sizetest extras fswreck patches
 
 ifdef BUILD_OCFS2CONSOLE
 SUBDIRS += ocfs2console
diff --git a/configure.in b/configure.in
index 246c8e7..5db6601 100644
--- a/configure.in
+++ b/configure.in
@@ -443,6 +443,7 @@ ocfs2_hb_ctl/ocfs2_hb_ctl.8
 ocfs2console/ocfs2console.8
 tunefs.ocfs2/tunefs.ocfs2.8
 o2image/o2image.8
+o2info/o2info.1
 libo2cb/o2cb.7
 vendor/common/ocfs2-tools.spec-generic
 ])
diff --git a/debian/ocfs2-tools.install b/debian/ocfs2-tools.install
index 4ca7d34..6c74383 100644
--- a/debian/ocfs2-tools.install
+++ b/debian/ocfs2-tools.install
@@ -6,6 +6,7 @@ sbin/mounted.ocfs2
 sbin/o2cb_ctl
 sbin/ocfs2_hb_ctl
 sbin/tunefs.ocfs2
+usr/bin/o2info
 usr/share/man/man8/debugfs.ocfs2.8
 usr/share/man/man8/fsck.ocfs2.8
 usr/share/man/man8/fsck.ocfs2.checks.8
@@ -16,3 +17,4 @@ usr/share/man/man7/o2cb.7
 usr/share/man/man8/o2cb_ctl.8
 usr/share/man/man8/ocfs2_hb_ctl.8
 usr/share/man/man8/tunefs.ocfs2.8
+usr/share/man/man1/o2info.1
diff --git a/debian/ocfs2-tools.manpages b/debian/ocfs2-tools.manpages
index 439fa68..22c1560 100644
--- a/debian/ocfs2-tools.manpages
+++ b/debian/ocfs2-tools.manpages
@@ -8,3 +8,4 @@ debian/tmp/usr/share/man/man8/o2cb_ctl.8
 debian/tmp/usr/share/man/man8/ocfs2_hb_ctl.8
 debian/tmp/usr/share/man/man8/o2image.8
 debian/tmp/usr/share/man/man7/o2cb.7
+debian/tmp/usr/share/man/man1/o2info.1
diff --git a/o2info/.gitignore b/o2info/.gitignore
new file mode 100644
index 0000000..46c8063
--- /dev/null
+++ b/o2info/.gitignore
@@ -0,0 +1,6 @@
+.*.sw?
+*.d
+.*.cmd
+stamp-md5
+cscope*
+o2info
diff --git a/o2info/Makefile b/o2info/Makefile
new file mode 100644
index 0000000..70d9cac
--- /dev/null
+++ b/o2info/Makefile
@@ -0,0 +1,38 @@
+TOPDIR = ..
+
+include $(TOPDIR)/Preamble.make
+
+WARNINGS = -Wall -Wstrict-prototypes -Wno-format -Wmissing-prototypes \
+           -Wmissing-declarations
+
+CFLAGS = $(OPTS) $(WARNINGS)
+
+LIBTOOLS_INTERNAL_LIBS = -L$(TOPDIR)/libtools-internal -ltools-internal
+LIBTOOLS_INTERNAL_DEPS = $(TOPDIR)/libtools-internal/libtools-internal.a
+
+LIBOCFS2_LIBS = -L$(TOPDIR)/libocfs2 -locfs2
+LIBOCFS2_DEPS = $(TOPDIR)/libocfs2/libocfs2.a
+
+BIN_PROGRAMS = o2info
+
+INCLUDES = -I$(TOPDIR)/include -I.
+DEFINES = -DVERSION=\"$(VERSION)\"
+
+MANS = o2info.1
+
+HFILES = o2info.h		\
+	 utils.h
+
+CFILES =			\
+	o2info.c		\
+	operations.c	\
+	utils.c
+
+OBJS = $(subst .c,.o,$(CFILES))
+
+DIST_FILES = $(CFILES) $(HFILES) o2info.1.in
+
+o2info: $(OBJS) $(LIBOCFS2_DEPS)
+	$(LINK) $(LIBOCFS2_LIBS) $(LIBTOOLS_INTERNAL_LIBS) $(COM_ERR_LIBS)
+
+include $(TOPDIR)/Postamble.make
diff --git a/o2info/o2info.1.in b/o2info/o2info.1.in
new file mode 100644
index 0000000..fe32d70
--- /dev/null
+++ b/o2info/o2info.1.in
@@ -0,0 +1,28 @@
+.TH "o2info" "1" "October 2010" "Version @VERSION@" "OCFS2 Manual Pages"
+.SH "NAME"
+o2info \- Dump \fIOCFS2\fR file system information on disk.
+.SH "SYNOPSIS"
+\fBo2info\fR <\fBdevice or file\fR>
+
+.SH "DESCRIPTION"
+.PP
+\fBo2info\fR is designed to be an information tool, to display \fIOCFS2\fR file system information on disk. Its main goal on one hand, is to provide a tool to display fs info in a comprehensive way and providing the information which may be missing in \fBdebugfs.ocfs\fR and \fBtunefs.ocfs2\fR such as global bitmap free space fragmentation and free inode info for each slot, on the other hand, it also aims to become a info tool(\fBnot\fR an administration one), which therefore allows all users who may have no read privilege on the underlying device to use the utility. In practice, \fB'o2info /path/to/file/on/ocfs2/vol'\fR use a new \fBOCFS2_IOC_INFO\fR ioctl to get info from fs for a mounted case. For a privileged user(e.g, root), the same info however, can also be accessed by \fB'o2info /dev/sdxN'\fR to direcly manipulate the raw device.
+
+.SH "OPTIONS"
+.TP
+\fB\-V, \-\-version\fR
+Show version and exit.
+
+.TP
+\fB\-h, \-\-help\fR
+Display help and exit.
+
+.SH "SEE ALSO"
+.BR debugfs.ocfs2(8)
+.BR tunefs.ocfs2(8)
+
+.SH "AUTHORS"
+Oracle Corporation
+
+.SH "COPYRIGHT"
+Copyright \(co 2010 Oracle. All rights reserved.
diff --git a/o2info/o2info.c b/o2info/o2info.c
new file mode 100644
index 0000000..02058af
--- /dev/null
+++ b/o2info/o2info.c
@@ -0,0 +1,484 @@
+/* -*- mode: c; c-basic-offset: 8; -*-
+ * vim: noexpandtab sw=8 ts=8 sts=0:
+ *
+ * o2info.c
+ *
+ * Ocfs2 utility to gather and report fs information
+ *
+ * Copyright (C) 2010 Oracle.  All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public
+ * License version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+#define _XOPEN_SOURCE 600
+#define _LARGEFILE64_SOURCE
+#define _GNU_SOURCE /* Because libc really doesn't want us using O_DIRECT? */
+
+#include <unistd.h>
+#include <errno.h>
+#include <signal.h>
+#include <getopt.h>
+#include <assert.h>
+
+#include "ocfs2/ocfs2.h"
+#include "ocfs2-kernel/ocfs2_ioctl.h"
+#include "ocfs2-kernel/kernel-list.h"
+#include "tools-internal/verbose.h"
+
+#include "utils.h"
+
+static LIST_HEAD(o2info_op_task_list);
+static int o2info_op_task_count;
+int cluster_coherent;
+
+void print_usage(int rc);
+static int help_handler(struct o2info_option *opt, char *arg)
+{
+	print_usage(0);
+	exit(0);
+}
+
+static int version_handler(struct o2info_option *opt, char *arg)
+{
+	tools_version();
+	exit(0);
+}
+
+static struct o2info_option help_option = {
+	.opt_option	= {
+		.name		= "help",
+		.val		= 'h',
+		.has_arg	= 0,
+		.flag		= NULL,
+	},
+	.opt_help	= NULL,
+	.opt_handler	= help_handler,
+	.opt_op		= NULL,
+	.opt_private = NULL,
+};
+
+static struct o2info_option version_option = {
+	.opt_option	= {
+		.name		= "version",
+		.val		= 'V',
+		.has_arg	= 0,
+		.flag		= NULL,
+	},
+	.opt_help	= NULL,
+	.opt_handler	= version_handler,
+	.opt_op		= NULL,
+	.opt_private = NULL,
+};
+
+static struct o2info_option *options[] = {
+	&help_option,
+	&version_option,
+	NULL,
+};
+
+void print_usage(int rc)
+{
+	int i;
+	enum tools_verbosity_level level = VL_ERR;
+
+	if (!rc)
+		level = VL_OUT;
+
+	verbosef(level, "Usage: %s [options] <device or file>\n",
+		 tools_progname());
+	verbosef(level, "       %s -h|--help\n", tools_progname());
+	verbosef(level, "       %s -V|--version\n", tools_progname());
+	verbosef(level, "[options] can be followings:\n");
+
+	for (i = 0; options[i]; i++) {
+		if (options[i]->opt_help)
+			verbosef(level, "\t%s\n", options[i]->opt_help);
+	}
+
+	exit(rc);
+}
+
+static int build_options(char **optstring, struct option **longopts)
+{
+	errcode_t err;
+	int i, num_opts, rc = 0;
+	int unprintable_counter;
+	size_t optstring_len;
+	char *p, *str = NULL;
+	struct option *lopts = NULL;
+	struct o2info_option *opt;
+
+	unprintable_counter = 1;	/* Start unique at CHAR_MAX + 1*/
+	optstring_len = 1;		/* For the leading ':' */
+	for (i = 0; options[i]; i++) {
+		opt = options[i];
+
+		/*
+		 * Any option with a val of CHAR_MAX wants an unique but
+		 * unreadable ->val.  Only readable characters go into
+		 * optstring.
+		 */
+		if (opt->opt_option.val == CHAR_MAX) {
+			opt->opt_option.val =
+				CHAR_MAX + unprintable_counter;
+			unprintable_counter++;
+			continue;
+		}
+
+		/*
+		 * A given option has a single character in optstring.
+		 * If it takes a mandatory argument, has_arg==1 and you add
+		 * a ":" to optstring.  If it takes an optional argument,
+		 * has_arg==2 and you add "::" to optstring.  Thus,
+		 * 1 + has_arg is the total space needed in opstring.
+		 */
+		optstring_len += 1 + opt->opt_option.has_arg;
+	}
+
+	num_opts = i;
+
+	err = ocfs2_malloc0(sizeof(char) * (optstring_len + 1), &str);
+	if (!err)
+		err = ocfs2_malloc(sizeof(struct option) * (num_opts + 1),
+				   &lopts);
+	if (err) {
+		rc = -ENOMEM;
+		goto out;
+	}
+
+	p = str;
+	*p++ = ':';
+	for (i = 0; options[i]; i++) {
+		assert(p < (str + optstring_len + 1));
+		opt = options[i];
+
+		memcpy(&lopts[i], &opt->opt_option, sizeof(struct option));
+
+		if (opt->opt_option.val >= CHAR_MAX)
+			continue;
+
+		*p = opt->opt_option.val;
+		p++;
+		if (opt->opt_option.has_arg > 0) {
+			*p = ':';
+			p++;
+		}
+		if (opt->opt_option.has_arg > 1) {
+			*p = ':';
+			p++;
+		}
+	}
+
+	/*
+	 * Fill last entry of options with zeros.
+	 */
+	memset(&lopts[i], 0, sizeof(struct option));
+
+out:
+	if (!rc) {
+		*optstring = str;
+		*longopts = lopts;
+	} else {
+		if (str)
+			free(str);
+		if (lopts)
+			free(lopts);
+	}
+
+	return rc;
+}
+
+static struct o2info_option *find_option_by_val(int val)
+{
+	int i;
+	struct o2info_option *opt = NULL;
+
+	for (i = 0; options[i]; i++) {
+		if (options[i]->opt_option.val == val) {
+			opt = options[i];
+			break;
+		}
+	}
+
+	return opt;
+}
+
+static errcode_t o2info_append_task(struct o2info_operation *o2p)
+{
+	errcode_t err;
+	struct o2info_op_task *task;
+
+	err = ocfs2_malloc0(sizeof(struct o2info_op_task), &task);
+	if (!err) {
+		task->o2p_task = o2p;
+		list_add_tail(&task->o2p_list, &o2info_op_task_list);
+		o2info_op_task_count++;
+	} else
+		ocfs2_free(&task);
+
+	return err;
+}
+
+static void o2info_free_op_task_list(void)
+{
+	struct o2info_op_task *task;
+	struct list_head *pos, *next;
+
+	if (list_empty(&o2info_op_task_list))
+		return;
+
+	list_for_each_safe(pos, next, &o2info_op_task_list) {
+		task = list_entry(pos, struct o2info_op_task, o2p_list);
+		list_del(pos);
+		ocfs2_free(&task);
+	}
+}
+
+extern int optind, opterr, optopt;
+extern char *optarg;
+static errcode_t parse_options(int argc, char *argv[], char **device_or_file)
+{
+	int c, lopt_idx = 0;
+	errcode_t err;
+	struct option *long_options = NULL;
+	char error[PATH_MAX];
+	char *optstring = NULL;
+	struct o2info_option *opt;
+
+	err = build_options(&optstring, &long_options);
+	if (err)
+		goto out;
+
+	opterr = 0;
+	error[0] = '\0';
+	while ((c = getopt_long(argc, argv, optstring,
+				long_options, &lopt_idx)) != EOF) {
+		opt = NULL;
+		switch (c) {
+		case '?':
+			if (optopt)
+				errorf("Invalid option: '-%c'\n", optopt);
+			else
+				errorf("Invalid option: '%s'\n",
+				       argv[optind - 1]);
+			print_usage(1);
+			break;
+
+		case ':':
+			if (optopt < CHAR_MAX)
+				errorf("Option '-%c' requires an argument\n",
+				       optopt);
+			else
+				errorf("Option '%s' requires an argument\n",
+				       argv[optind - 1]);
+			print_usage(1);
+			break;
+
+		default:
+			opt = find_option_by_val(c);
+			if (!opt) {
+				errorf("Shouldn't have gotten here: "
+				       "option '-%c'\n", c);
+				print_usage(1);
+			}
+
+			if (optarg)
+				opt->opt_private = (void *)optarg;
+
+			break;
+		}
+
+		if (opt->opt_set) {
+			errorf("Option '-%c' specified more than once\n",
+			       c);
+			print_usage(1);
+		}
+
+		opt->opt_set = 1;
+		/*
+		 * Handlers for simple options such as showing version,
+		 * printing the usage, or specify the coherency etc.
+		 */
+		if (opt->opt_handler) {
+			if (opt->opt_handler(opt, optarg))
+				print_usage(1);
+		}
+
+		/*
+		 * Real operation will be added to a list to run later.
+		 */
+		if (opt->opt_op) {
+			opt->opt_op->to_private = opt->opt_private;
+			err = o2info_append_task(opt->opt_op);
+			if (err)
+				goto out;
+		}
+	}
+
+	if (optind == 1)
+		print_usage(1);
+
+	if (optind >= argc) {
+		errorf("No device or file specified\n");
+		print_usage(1);
+	}
+
+	*device_or_file = strdup(argv[optind]);
+	if (!*device_or_file) {
+		errorf("No memory for allocation\n");
+		goto out;
+	}
+
+	optind++;
+
+	if (optind < argc) {
+		errorf("Too many arguments\n");
+		print_usage(1);
+	}
+
+out:
+	if (optstring)
+		ocfs2_free(&optstring);
+
+	if (long_options)
+		ocfs2_free(&long_options);
+
+	return err;
+}
+
+static errcode_t o2info_run_task(struct o2info_method *om)
+{
+	struct list_head *p, *n;
+	struct o2info_op_task *task;
+
+	list_for_each_safe(p, n, &o2info_op_task_list) {
+		task = list_entry(p, struct o2info_op_task, o2p_list);
+		task->o2p_task->to_run(task->o2p_task, om,
+				       task->o2p_task->to_private);
+	}
+
+	return 0;
+}
+
+static void handle_signal(int caught_sig)
+{
+	int exitp = 0, abortp = 0;
+	static int segv_already;
+
+	switch (caught_sig) {
+	case SIGQUIT:
+		abortp = 1;
+		/* FALL THROUGH */
+
+	case SIGTERM:
+	case SIGINT:
+	case SIGHUP:
+		errorf("Caught signal %d, exiting\n", caught_sig);
+		exitp = 1;
+		break;
+
+	case SIGSEGV:
+		errorf("Segmentation fault, exiting\n");
+		exitp = 1;
+		if (segv_already) {
+			errorf("Segmentation fault loop detected\n");
+			abortp = 1;
+		} else
+			segv_already = 1;
+		break;
+
+	default:
+		errorf("Caught signal %d, ignoring\n", caught_sig);
+		break;
+	}
+
+	if (!exitp)
+		return;
+
+	if (abortp)
+		abort();
+
+	exit(1);
+}
+
+static int setup_signals(void)
+{
+	int rc = 0;
+	struct sigaction act;
+
+	act.sa_sigaction = NULL;
+	sigemptyset(&act.sa_mask);
+	act.sa_handler = handle_signal;
+#ifdef SA_INTERRUPT
+	act.sa_flags = SA_INTERRUPT;
+#endif
+	rc += sigaction(SIGTERM, &act, NULL);
+	rc += sigaction(SIGINT, &act, NULL);
+	rc += sigaction(SIGHUP, &act, NULL);
+	rc += sigaction(SIGQUIT, &act, NULL);
+	rc += sigaction(SIGSEGV, &act, NULL);
+	act.sa_handler = SIG_IGN;
+	rc += sigaction(SIGPIPE, &act, NULL);  /* Get EPIPE instead */
+
+	return rc;
+}
+
+static void o2info_init(const char *argv0)
+{
+	initialize_ocfs_error_table();
+
+	tools_setup_argv0(argv0);
+
+	setbuf(stdout, NULL);
+	setbuf(stderr, NULL);
+
+	if (setup_signals()) {
+		errorf("Unable to setup signal handling \n");
+		exit(1);
+	}
+
+	cluster_coherent = 0;
+}
+
+int main(int argc, char *argv[])
+{
+	int rc = 0;
+
+	char *device_or_file = NULL;
+	static struct o2info_method om;
+
+	o2info_init(argv[0]);
+	parse_options(argc, argv, &device_or_file);
+
+	rc = o2info_method(device_or_file);
+	if (rc < 0)
+		goto out;
+	else
+		om.om_method = rc;
+
+	strncpy(om.om_path, device_or_file, PATH_MAX);
+
+	rc = o2info_open(&om, 0);
+	if (rc)
+		goto out;
+
+	rc = o2info_run_task(&om);
+	if (rc)
+		goto out;
+
+	o2info_free_op_task_list();
+
+	rc = o2info_close(&om);
+out:
+	if (device_or_file)
+		ocfs2_free(&device_or_file);
+
+	return rc;
+}
diff --git a/o2info/o2info.h b/o2info/o2info.h
new file mode 100644
index 0000000..9290f81
--- /dev/null
+++ b/o2info/o2info.h
@@ -0,0 +1,82 @@
+/* -*- mode: c; c-basic-offset: 8; -*-
+ * vim: noexpandtab sw=8 ts=8 sts=0:
+ *
+ * o2info.h
+ *
+ * o2info operation prototypes.
+ *
+ * Copyright (C) 2010 Oracle.  All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public
+ * License version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+#ifndef __O2INFO_H__
+#define __O2INFO_H__
+
+#include <getopt.h>
+
+#include "ocfs2/ocfs2.h"
+#include "ocfs2-kernel/kernel-list.h"
+
+enum o2info_method_type {
+	O2INFO_USE_LIBOCFS2 = 1,
+	O2INFO_USE_IOCTL,
+	O2INFO_USE_NUMTYPES
+};
+
+struct o2info_method {
+	enum o2info_method_type om_method;
+	char om_path[PATH_MAX];
+	union {
+		ocfs2_filesys *om_fs;	/* Use libocfs2 for device */
+		int om_fd;		/* Use ioctl for file */
+	};
+};
+
+struct o2info_operation {
+	char            *to_name;
+	int             (*to_run)(struct o2info_operation *op,
+				 struct o2info_method *om,
+				 void *arg);
+	void            *to_private;
+};
+
+struct o2info_option {
+	struct option	opt_option;		/* For getopt_long().  If
+						   there is no short
+						   option, set .val to
+						   CHAR_MAX.  A unique
+						   value will be inserted
+						   by the code. */
+	struct o2info_operation *opt_op;
+
+	char		*opt_help;	/* Help string */
+	int		opt_set;	/* Was this option seen */
+	int		(*opt_handler)(struct o2info_option *opt, char *arg);
+	void		*opt_private;
+};
+
+struct o2info_op_task {
+	struct list_head o2p_list;
+	struct o2info_operation *o2p_task;
+};
+
+#define __O2INFO_OP(_name, _run, _private)				\
+{									\
+	.to_name		= #_name,				\
+	.to_run			= _run,					\
+	.to_private		= _private				\
+}
+
+#define DEFINE_O2INFO_OP(_name, _run, _private)				\
+struct o2info_operation	_name##_op =					\
+	__O2INFO_OP(_name, _run, _private)
+
+#endif  /* __O2INFO_H__ */
diff --git a/o2info/operations.c b/o2info/operations.c
new file mode 100644
index 0000000..14214fe
--- /dev/null
+++ b/o2info/operations.c
@@ -0,0 +1,61 @@
+/* -*- mode: c; c-basic-offset: 8; -*-
+ * vim: noexpandtab sw=8 ts=8 sts=0:
+ *
+ * operations.c
+ *
+ * Implementations for all o2info's operation.
+ *
+ * Copyright (C) 2010 Oracle.  All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public
+ * License version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+#define _XOPEN_SOURCE 600
+#define _LARGEFILE64_SOURCE
+#define _GNU_SOURCE /* Because libc really doesn't want us using O_DIRECT? */
+
+#include <errno.h>
+#include <sys/raw.h>
+#include <inttypes.h>
+
+#include "ocfs2/ocfs2.h"
+#include "ocfs2/bitops.h"
+#include "ocfs2-kernel/ocfs2_ioctl.h"
+#include "ocfs2-kernel/kernel-list.h"
+#include "tools-internal/verbose.h"
+
+#include "utils.h"
+
+extern void print_usage(int rc);
+extern int cluster_coherent;
+
+static inline void o2info_fill_request(struct ocfs2_info_request *req,
+				       size_t size,
+				       enum ocfs2_info_type code,
+				       int flags)
+{
+	memset(req, 0, size);
+
+	req->ir_magic = OCFS2_INFO_MAGIC;
+	req->ir_size = size;
+	req->ir_code = code,
+	req->ir_flags = flags;
+}
+
+static void o2i_error(struct o2info_operation *op, const char *fmt, ...)
+{
+	va_list ap;
+
+	fprintf(stderr, "%s: ", op->to_name);
+	va_start(ap, fmt);
+	vfprintf(stderr, fmt, ap);
+
+	return;
+}
diff --git a/o2info/utils.c b/o2info/utils.c
new file mode 100644
index 0000000..0911c50
--- /dev/null
+++ b/o2info/utils.c
@@ -0,0 +1,109 @@
+/* -*- mode: c; c-basic-offset: 8; -*-
+ * vim: noexpandtab sw=8 ts=8 sts=0:
+ *
+ * utils.c
+ *
+ * utility functions for o2info
+ *
+ * Copyright (C) 2010 Oracle.  All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public
+ * License version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+#define _XOPEN_SOURCE 600
+#define _LARGEFILE64_SOURCE
+#define _GNU_SOURCE /* Because libc really doesn't want us using O_DIRECT? */
+
+#include <unistd.h>
+#include <errno.h>
+#include <pwd.h>
+#include <grp.h>
+
+#include "ocfs2/ocfs2.h"
+#include "tools-internal/verbose.h"
+
+#include "utils.h"
+
+errcode_t o2info_open(struct o2info_method *om, int flags)
+{
+	errcode_t err = 0;
+	int fd, open_flags;
+	ocfs2_filesys *fs = NULL;
+
+	if (om->om_method == O2INFO_USE_LIBOCFS2) {
+		open_flags = flags|OCFS2_FLAG_HEARTBEAT_DEV_OK|OCFS2_FLAG_RO;
+		err = ocfs2_open(om->om_path, open_flags, 0, 0, &fs);
+		if (err) {
+			tcom_err(err, "while opening device %s", om->om_path);
+			goto out;
+		}
+		om->om_fs = fs;
+	} else {
+		open_flags = flags | O_RDONLY;
+		fd = open(om->om_path, open_flags);
+		if (fd < 0) {
+			err = errno;
+			tcom_err(err, "while opening file %s", om->om_path);
+			goto out;
+		}
+		om->om_fd = fd;
+	}
+
+out:
+	return err;
+}
+
+errcode_t o2info_close(struct o2info_method *om)
+{
+	errcode_t err = 0;
+	int rc = 0;
+
+	if (om->om_method == O2INFO_USE_LIBOCFS2) {
+		if (om->om_fs) {
+			err = ocfs2_close(om->om_fs);
+			if (err) {
+				tcom_err(err, "while closing device");
+				goto out;
+			}
+		}
+	} else {
+		if (om->om_fd >= 0) {
+			rc = close(om->om_fd);
+			if (rc < 0) {
+				rc = errno;
+				tcom_err(rc, "while closing fd: %d.\n",
+					 om->om_fd);
+				err = rc;
+			}
+		}
+	}
+
+out:
+	return err;
+}
+
+int o2info_method(const char *path)
+{
+	int rc;
+	struct stat st;
+
+	rc = stat(path, &st);
+	if (rc < 0) {
+		tcom_err(errno, "while stating %s", path);
+		goto out;
+	}
+
+	rc = O2INFO_USE_IOCTL;
+	if ((S_ISBLK(st.st_mode)) || (S_ISCHR(st.st_mode)))
+		rc = O2INFO_USE_LIBOCFS2;
+
+out:
+	return rc;
+}
diff --git a/o2info/utils.h b/o2info/utils.h
new file mode 100644
index 0000000..6d55d39
--- /dev/null
+++ b/o2info/utils.h
@@ -0,0 +1,30 @@
+/* -*- mode: c; c-basic-offset: 8; -*-
+ * vim: noexpandtab sw=8 ts=8 sts=0:
+ *
+ * utils.h
+ *
+ * Common utility function prototypes
+ *
+ * Copyright (C) 2010 Oracle.  All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public
+ * License version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+#ifndef __UTILS_H__
+#define __UTILS_H__
+
+#include "o2info.h"
+
+int o2info_method(const char *path);
+
+errcode_t o2info_open(struct o2info_method *om, int flags);
+errcode_t o2info_close(struct o2info_method *om);
+
+#endif		/* __UTILS_H__ */
diff --git a/vendor/common/ocfs2-tools.spec-generic.in b/vendor/common/ocfs2-tools.spec-generic.in
index 3e9b46a..0192c48 100644
--- a/vendor/common/ocfs2-tools.spec-generic.in
+++ b/vendor/common/ocfs2-tools.spec-generic.in
@@ -119,6 +119,7 @@ fi
 /sbin/mount.ocfs2
 /sbin/o2image
 /sbin/ocfs2_hb_ctl
+/usr/bin/o2info
 /etc/init.d/o2cb
 /etc/init.d/ocfs2
 %config(noreplace) /etc/sysconfig/o2cb
@@ -133,6 +134,7 @@ fi
 /usr/share/man/man8/ocfs2_hb_ctl.8.gz
 /usr/share/man/man8/o2image.8.gz
 /usr/share/man/man7/o2cb.7.gz
+/usr/share/man/man1/o2info.1.gz
 
 
 %files -n ocfs2console
-- 
1.5.5
