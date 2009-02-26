From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Thu, 26 Feb 2009 15:00:36 -0800
Subject: [Ocfs2-devel] o2dlm mle hash patches - round 2
Message-ID: <1235689249-2693-1-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

The changes from the last drop are:

1. Patch 11 removes struct dlm_lock_name.

2. Patch 12 is an unrelated bugfix. Actually is related to a bugfix
that we are retracting in mainline currently. The patch may need more testing.
While I did hit the condition in my testing, Marcos hasn't. I am sending it
because it can be queued for 2.6.30. Give us more time to test.

3. Patch 13 will be useful when we later attempt to size the mle hash appropriately.

Sunil
