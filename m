From: Andrew Morton <akpm@linux-foundation.org>
Date: Wed, 12 Jun 2019 18:18:13 -0700
Subject: [Ocfs2-devel] mmotm 2019-06-11-16-59 uploaded (ocfs2)
In-Reply-To: <492b4bcc-4760-7cbb-7083-9f22e7ab4b82@infradead.org>
References: <20190611235956.4FZF6%akpm@linux-foundation.org>
	<492b4bcc-4760-7cbb-7083-9f22e7ab4b82@infradead.org>
Message-ID: <20190612181813.48ad05832e05f767e7116d7b@linux-foundation.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Randy Dunlap <rdunlap@infradead.org>
Cc: broonie@kernel.org, mhocko@suse.cz, sfr@canb.auug.org.au, linux-next@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, mm-commits@vger.kernel.org, ocfs2-devel@oss.oracle.com, Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>, Joseph Qi <joseph.qi@linux.alibaba.com>

On Wed, 12 Jun 2019 07:15:30 -0700 Randy Dunlap <rdunlap@infradead.org> wrote:

> On 6/11/19 4:59 PM, akpm at linux-foundation.org wrote:
> > The mm-of-the-moment snapshot 2019-06-11-16-59 has been uploaded to
> > 
> >    https://urldefense.proofpoint.com/v2/url?u=http-3A__www.ozlabs.org_-7Eakpm_mmotm_&d=DwICAg&c=RoP1YumCXCgaWHvlZYR8PZh8Bv7qIrMUB65eapI_JnE&r=C7gAd4uDxlAvTdc0vmU6X8CMk6L2iDY8-HD0qT6Fo7Y&m=zWoF0Bft4OzQeAaZXMGI56DN7p9MjLynOay4PZYAlhQ&s=vYmeDBOk3Nv08-ZA7IweIdaUk094Ldvmgzc20fjjzDs&e=
> > 
> > mmotm-readme.txt says
> > 
> > README for mm-of-the-moment:
> > 
> > https://urldefense.proofpoint.com/v2/url?u=http-3A__www.ozlabs.org_-7Eakpm_mmotm_&d=DwICAg&c=RoP1YumCXCgaWHvlZYR8PZh8Bv7qIrMUB65eapI_JnE&r=C7gAd4uDxlAvTdc0vmU6X8CMk6L2iDY8-HD0qT6Fo7Y&m=zWoF0Bft4OzQeAaZXMGI56DN7p9MjLynOay4PZYAlhQ&s=vYmeDBOk3Nv08-ZA7IweIdaUk094Ldvmgzc20fjjzDs&e=
> > 
> > This is a snapshot of my -mm patch queue.  Uploaded at random hopefully
> > more than once a week.
> 
> 
> on i386:
> 
> ld: fs/ocfs2/dlmglue.o: in function `ocfs2_dlm_seq_show':
> dlmglue.c:(.text+0x46e4): undefined reference to `__udivdi3'

Thanks.  This, I guess:

--- a/fs/ocfs2/dlmglue.c~ocfs2-add-locking-filter-debugfs-file-fix
+++ a/fs/ocfs2/dlmglue.c
@@ -3115,7 +3115,7 @@ static int ocfs2_dlm_seq_show(struct seq
 		 * otherwise, only dump the last N seconds active lock
 		 * resources.
 		 */
-		if ((now - last) / 1000000 > dlm_debug->d_filter_secs)
+		if (div_u64(now - last, 1000000) > dlm_debug->d_filter_secs)
 			return 0;
 	}
 #endif

review and test, please?
