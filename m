From: Julia Lawall <julia@diku.dk>
Date: Wed, 4 Aug 2010 22:15:22 +0200 (CEST)
Subject: [Ocfs2-devel] question about fs/ocfs2/dlm/dlmrecovery.c
Message-ID: <Pine.LNX.4.64.1008042208270.30592@ask.diku.dk>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

The following code in the function dlm_process_recovery_data looks 
suspicious:

list_for_each_entry(lock, tmpq, list) {
	if (lock->ml.cookie != ml->cookie)
           	lock = NULL;
	else
                break;
}

list_for_each_entry moves around the list using its first argument, so it
doesn't seem safe to set that to NULL.  Maybe the "else" is not supposed to
be there?

julia
