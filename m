From: Daniel Phillips <phillips@google.com>
Date: Wed, 31 May 2006 13:56:34 -0700
Subject: [Ocfs2-devel] dlm_pick_recovery_master algorithm?
Message-ID: <447E0302.2080109@google.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi,

I'm trying to understand the dlm_pick_recovery_master algorithm and I have
a few questions.  Which node masters the $RECOVERY resource?  Where is that
set?  What happens when that node dies?  Why can dlm_pick_recovery_master
get the EX on $RECOVERY and still not be the recovery master?

Regards,

Daniel
