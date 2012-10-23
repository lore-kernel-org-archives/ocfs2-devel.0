From: Joel Becker <jlbec@evilplan.org>
Date: Tue, 23 Oct 2012 02:02:32 -0700
Subject: [Ocfs2-devel] [PATCH 06/21] ocfs2: drop vmtruncate
In-Reply-To: <CANGUGtB0VR4hnRf5hk3_7Rc23fo5ejtj3J2yZZ50tD_Tk+sigw@mail.gmail.com>
References: <508296B4.60508@gmail.com> <20121023085448.GM5635@localhost>
	<CANGUGtB0VR4hnRf5hk3_7Rc23fo5ejtj3J2yZZ50tD_Tk+sigw@mail.gmail.com>
Message-ID: <20121023090232.GA13027@localhost>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Marco Stornelli <marco.stornelli@gmail.com>
Cc: Linux FS Devel <linux-fsdevel@vger.kernel.org>, Mark Fasheh <mfasheh@suse.com>, ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org

On Tue, Oct 23, 2012 at 10:58:42AM +0200, Marco Stornelli wrote:
> 2012/10/23 Joel Becker <jlbec@evilplan.org>:
> > On Sat, Oct 20, 2012 at 02:19:00PM +0200, Marco Stornelli wrote:
> >> Removed vmtruncate
> >>
> >> Signed-off-by: Marco Stornelli <marco.stornelli@gmail.com>
> >
> > Acked-by: Joel Becker <jlbec@evilplan.org>
> >
> > Do you want me to pull this, or are you going to send it with your set?
> >
> > Joel
> >
> 
> I'd prefer to push all via Al's tree since there is a VFS change.

SGTM.  Thanks!

Joel

> 
> Marco
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo at vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 

"In the long run...we'll all be dead."
                                        -Unknown

			http://www.jlbec.org/
			jlbec at evilplan.org
