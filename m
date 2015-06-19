From: Tariq Saeed <tariq.x.saeed@oracle.com>
Date: Thu, 18 Jun 2015 18:12:23 -0700
Subject: [Ocfs2-devel] ftrace question about ocfs2
Message-ID: <55836C77.3090003@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi,
I apologize for using this list but no response to my query from 
individual email.
There are trace calls like all over the code that seem to write into the 
ftrace buffer.
trace_ocfs2_lookup(dir, dentry, dentry->d_name.len,
                            dentry->d_name.name,
                            (unsigned long long)OCFS2_I(dir)->ip_blkno, 0);

But ftrace only shows fn name. No arguments. For example here is a 
snippet from ls command.
               ls-8932  [000] 10729002.743220: ocfs2_lookup <-do_lookup
               ls-8932  [000] 10729002.743227: 
ocfs2_inode_lock_full_nested <-ocfs2_lookup

How do I get it to write args in the buffer and then display.

Thank You.
-Tariq Saeed
