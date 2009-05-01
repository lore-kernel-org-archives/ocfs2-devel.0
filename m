From: wengang wang <wen.gang.wang@oracle.com>
Date: Fri,  1 May 2009 12:55:27 +0800
Subject: [Ocfs2-devel] [PATCH 0/3] OCFS2: speed up dlm_lock_resouce
	hash_table lookups
Message-ID: <200905010456.n414udas012980@acsinet15.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

backporting from mainline. --http://kernel.us.oracle.com/~smushran/srini/
#I think the first line of the 3 patches contain mainline git commit, does them?

enlarge hash_table capacity to fasten hash_table lookups.
