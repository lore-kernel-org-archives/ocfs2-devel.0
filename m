From: Andrew Morton <akpm@linux-foundation.org>
Date: Mon, 18 Dec 2017 17:27:39 -0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: fall back to buffer IO when append
 dio is disabled with file hole existing
In-Reply-To: <75d5dcf3-b324-1eaa-f3c8-37e08a71ba92@gmail.com>
References: <63ADC13FD55D6546B7DECE290D39E373F1F5C2CE@H3CMLB14-EX.srv.huawei-3com.com>
	<20171218135358.cee63b6019681cd7cfc569ee@linux-foundation.org>
	<75d5dcf3-b324-1eaa-f3c8-37e08a71ba92@gmail.com>
Message-ID: <20171218172739.97f965cef24a4421ceb943bd@linux-foundation.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, 19 Dec 2017 09:24:17 +0800 Joseph Qi <jiangqi903@gmail.com> wrote:

> > --- a/fs/ocfs2/aops.c~ocfs2-fall-back-to-buffer-io-when-append-dio-is-disabled-with-file-hole-existing-fix
> > +++ a/fs/ocfs2/aops.c
> > @@ -2469,10 +2469,9 @@ static int ocfs2_dio_end_io(struct kiocb
> >   * Will look for holes and unwritten extents in the range starting at
> >   * pos for count bytes (inclusive).
> >   */
> > -static int ocfs2_check_range_for_holes(struct inode *inode, loff_t pos,
> > -				       size_t count)
> > +static bool ocfs2_range_has_holes(struct inode *inode, loff_t pos, size_t count)
> >  {
> > -	int ret = 0;
> > +	bool ret = false;
> 
> I have a different opinion here. If we change return value from int to
> bool, the error returned by ocfs2_get_clusters cannot be reflected. So
> I'd prefer the original version.

But that error code is not used?
