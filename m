From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Tue,  3 Feb 2009 12:48:14 -0800
Subject: [Ocfs2-devel] Convert mle list to a hash
Message-ID: <1233694104-29710-1-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

These patches convert the mle list to a hash. The same patches apply on
ocfs2 1.4 too.

Currently, we use the same number of hash pages for mles and lockres'.
This will be addressed in a future patch that will make both of them
configurable.

Sunil
