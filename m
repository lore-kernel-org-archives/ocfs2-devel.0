From: Tao Ma <tao.ma@oracle.com>
Date: Fri, 18 Dec 2009 10:10:16 +0800
Subject: [Ocfs2-devel] [PATCH 0/2] 2 bug fixes for reflink in ocfs2.
Message-ID: <4B2AE488.8070602@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Joel,
	These are 2 bug fixes for reflink.
	Although these 2 are both one line fix, they are important.
[PATCH 1/2] resolves a bug tristan found serveral months ago. I tracked 
it down recently. It is really race.
[PATCH 2/2] is found when I tested a corruption in reflink. It resolved 
a bug that the file can't be replayed successfully in orphan dir.

I have run tristan's test cases against these 2 fixes the whole week. 
They should be stable enough to be integrated.

Regards,
Tao
