From: abeekhof@suse.de <abeekhof@suse.de>
Date: Fri Dec  1 00:27:53 2006
Subject: [Ocfs2-devel] [patch 0/3] OCFS Configurable timeouts - Revision 4
Message-ID: <20061201082328.841791000@suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Use the atomic_read() macro instead of accessing the atomic_t struct directly.

--

Andrew
