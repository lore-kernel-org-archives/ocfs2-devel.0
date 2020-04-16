From: Andrew Morton <akpm@linux-foundation.org>
Date: Wed, 15 Apr 2020 20:02:01 -0700
Subject: [Ocfs2-devel] [PATCH 3/5] ocfs2: Add missing annotation for
 dlm_empty_lockres()
In-Reply-To: <5408edd7-87a9-ac56-5c52-c2a19c308311@linux.alibaba.com>
References: <0/5> <20200403160505.2832-1-jbi.octave@gmail.com>
	<20200403160505.2832-4-jbi.octave@gmail.com>
	<5408edd7-87a9-ac56-5c52-c2a19c308311@linux.alibaba.com>
Message-ID: <20200415200201.2efbbbd338a43a2f57988e2d@linux-foundation.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Jules Irenge <jbi.octave@gmail.com>, linux-kernel@vger.kernel.org, boqun.feng@gmail.com, Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>, Gang He <ghe@suse.com>, Richard Fontana <rfontana@redhat.com>, Allison Randal <allison@lohutok.net>, Thomas Gleixner <tglx@linutronix.de>, Aditya Pakki <pakki001@umn.edu>, ChenGang <cg.chen@huawei.com>, Masahiro Yamada <masahiroy@kernel.org>, "moderated list:ORACLE CLUSTER FILESYSTEM 2 (OCFS2)" <ocfs2-devel@oss.oracle.com>

On Sat, 4 Apr 2020 07:45:49 +0800 Joseph Qi <joseph.qi@linux.alibaba.com> wrote:

> On 2020/4/4 00:05, Jules Irenge wrote:
> > Sparse reports a warning at dlm_empty_lockres()
> > 
> > warning: context imbalance in dlm_purge_lockres() - unexpected unlock
> > 
> > The root cause is the missing annotation at dlm_purge_lockres()
> > 
> > Add the missing __must_hold(&dlm->spinlock)
> > 
> Seems this is duplicate with assert_spin_locked()?

I doubt is sparse is smart enough to treat assert_spin_locked() as
equivalent to __must_hold().  It would be neat though.
