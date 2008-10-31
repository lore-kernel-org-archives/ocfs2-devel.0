From: Jan Kara <jack@suse.cz>
Date: Fri, 31 Oct 2008 07:38:50 +0100
Subject: [Ocfs2-devel] [PATCH 00/27] Quotas for OCFS2 (version 3)
In-Reply-To: y
References: y
Message-ID: <12254351572189-git-send-email-jack@suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi,

in this thread comes the third version of the patches implementing quotas for
OCFS2 (sorry for spamming ocfs2-devel so often with such a big pile of patches
;). I've now addressed all Joel's comments (feature bits added among supported
bits in the last patch, hopefully fixed an oops when enabling quota fails on
mount), also fixed a bug Tristan reported (message about exceeding softlimit
was not always properly printed), fixed a bug in node recovery leading to
possible oops when filesystem was without quotas (reported by Andrew Beekhof)
and also reported a few style things and compilation problems reported
by Andrew Morton and other people getting the patches via -mm kernel.  As
always, comments are welcome (but I won't respond quickly because I'll be
mostly out of email for next two weeks).
								Honza
