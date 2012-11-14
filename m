From: Lars Marowsky-Bree <lmb@suse.de>
Date: Wed, 14 Nov 2012 11:01:30 +0100
Subject: [Ocfs2-devel] fcntl(F_SETLK) returning ENOSYS
Message-ID: <20121114100130.GF9295@suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi all,

tracing a couple of reports here (on a somewhat older version of OCFS2,
with a user-space/pacemaker/dlm_controld.pcmk stack) where we see
fnctl(F_SETLK) return ENOSYS. This happens after a node has failed/been
fenced and recovered. It affects only individual mounts, not the whole
system.

The only code path that I can see so far that could lead to ENOSYS being
returned here is from within dlm_controld:process_plocks() if
disable_plocks == 1. But I can't find the tell tale log message that I
think we should see (from store_plocks) if this value was set.

We'll continue investigating, but perhaps this rings a bell for someone
and we can shorten the latency ;-) Thanks for any insights.


Regards,
    Lars

-- 
Architect Storage/HA
SUSE LINUX Products GmbH, GF: Jeff Hawn, Jennifer Guild, Felix Imend?rffer, HRB 21284 (AG N?rnberg)
"Experience is the name everyone gives to their mistakes." -- Oscar Wilde
