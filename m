From: Wengang Wang <wen.gang.wang@oracle.com>
Date: Fri, 23 Jul 2010 09:41:14 +0800
Subject: [Ocfs2-devel] [TRIVIAL] [PATCH] Remove unnecessary goto
 statements
In-Reply-To: <AANLkTim40MkUboQNTLkt1tju9u4dEzAifqBPB0_NIYh6@mail.gmail.com>
References: <AANLkTilVfUTA63SEMhnaagn-mmmEWwfKgogpYcJwdqxA@mail.gmail.com>
	<20100722152207.GB3973@laptop.jp.oracle.com>
	<AANLkTim40MkUboQNTLkt1tju9u4dEzAifqBPB0_NIYh6@mail.gmail.com>
Message-ID: <20100723014114.GA2390@laptop.jp.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 10-07-22 14:34, Goldwyn Rodrigues wrote:
> On Thu, Jul 22, 2010 at 10:22 AM, Wengang Wang <wen.gang.wang@oracle.com> wrote:
> >> -bail:
> >> ? ? ? return status;
> >> ?}
> >>
> >> @@ -1050,7 +1048,6 @@ static inline int
> >> ocfs2_block_group_set_bits(handle_t *handle,
> >> ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ?group_bh);
> >> ? ? ? if (status < 0) {
> >> ? ? ? ? ? ? ? mlog_errno(status);
> >> - ? ? ? ? ? ? goto bail;
> >> ? ? ? }
> >
> > Why this?
> > the following lines are modifying the buffer head.
> >
> > 1361 ? ? ? ? le16_add_cpu(&bg->bg_free_bits_count, -num_bits);
> > 1362 ? ? ? ? while(num_bits--)
> > 1363 ? ? ? ? ? ? ? ? ocfs2_set_bit(bit_off++, bitmap);
> > 1364
> > 1365 ? ? ? ? ocfs2_journal_dirty(handle, group_bh);
> > 1366
> > 1367 bail:
> >
> > For the next read of this group descriptor, we can't be sure it will be dirty
> > read. So that it may get wrong contents and then the following write will write
> > the wrong contents to disk.
> 
> 
> Not sure which codebase you are referring to. According to the patch
> and the code in the Joel's git repo from kernel.org, the statement
> immediately following this was a bail tag.

Oh, sorry. I made a mistake for this.

regards,
wengang.
