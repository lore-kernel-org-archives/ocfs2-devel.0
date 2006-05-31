From: Daniel Phillips <phillips@google.com>
Date: Wed, 31 May 2006 16:01:36 -0700
Subject: [Ocfs2-devel] dlm_pick_recovery_master algorithm?
In-Reply-To: <20060531142520708.00000000956@khackel-us>
References: <20060531142520708.00000000956@khackel-us>
Message-ID: <447E2050.4030204@google.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Thanks Kurt, great answers!

 > You wrote:
> One note on all of this: this is NOT how we would like to do recovery
> going forward, we just did not have a solid cluster membership service
 > in place that we could use when the mastery/recovery code was written.
 > Once we do have a stable mechanism and API (stop/start/finish) to depend
 > upon, I would like to rewrite the whole thing for lock-table-based mastery
 > and much more sensible recovery.

What is the pedigree of that stop/start/finish API?  Is it the only stable
mechanism you know of to build a more sensible recovery on?

 > As it stands, it's a brittle structure
 > that has to continually try to detect node failures inline and make
 > adjustments as recovery is ongoing, which is no fun.

Not to mention, slow and not obviously terminating, indeed.

Regards,

Daniel
