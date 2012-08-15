From: Sunil Mushran <sunil.mushran@gmail.com>
Date: Wed, 15 Aug 2012 11:03:36 -0700
Subject: [Ocfs2-devel] ocfs2/cluster: Clean up messages in o2net
In-Reply-To: <20120809122205.GD3683@mwanda>
References: <20110826010109.GA27582@shale.localdomain>
	<4E5D529C.5020706@oracle.com> <20120809122205.GD3683@mwanda>
Message-ID: <CAEeiSHU4nr2+6amQqTGsUFhEZNjvK8OZtT=WGNCN5jw3TgD0Uw@mail.gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

The patch is not in mainline. I am putting together a branch for Joel to
pull.

On Thu, Aug 9, 2012 at 5:22 AM, Dan Carpenter <dan.carpenter@oracle.com>wrote:

> This is still here.  I'm not sure why this error message just showed
> up in linux-next again.  Odd.
>
> regards,
> dan carpenter
>
> On Tue, Aug 30, 2011 at 02:14:04PM -0700, Sunil Mushran wrote:
> > Thanks. I'll fix the two.
> >
> > On 08/25/2011 06:01 PM, Dan Carpenter wrote:
> > >Hello Sunil Mushran,
> > >
> > >1dfecf810e0e: "ocfs2/cluster: Clean up messages in o2net"
> > >Leads to the following Smatch complaint:
> > >fs/ocfs2/cluster/tcp.c +1704 o2net_start_connect(101)
> > >      error: we previously assumed 'sc' could be null (see line 1650)
> > >
> > >fs/ocfs2/cluster/tcp.c
> > >   1649              sc = sc_alloc(node);
> > >   1650              if (sc == NULL) {
> > >   1651                      mlog(0, "couldn't allocate sc\n");
> > >   1652                      ret = -ENOMEM;
> > >   1653                      goto out;
> > >   1654              }
> > >   1655
> > >
> > >--- [snip] ---
> > >
> > >   1701      out:
> > >   1702              if (ret) {
> > >   1703                      printk(KERN_NOTICE "o2net: Connect attempt
> to " SC_NODEF_FMT
> > >   1704                             " failed with errno %d\n",
> SC_NODEF_ARGS(sc), ret);
> > >
>   ^^
> > >Null dereference here.
> > >
> > >   1705                      /* 0 err so that another will be queued
> and attempted
> > >   1706                       * from set_nn_state */
> > >
> > >This email is from my new semi-automatic bug reporting tool script.
> > >Btw, Smatch complains about this as well:
> > >
> > >fs/ocfs2/cluster/tcp.c +549 o2net_set_nn_state(44)
> > >     error: we previously assumed 'old_sc' could be null (see line 517)
> > >
> > >These dereferences were disabled in my old config, but Smatch detects
> > >them now that we're using normal printk()
> > >
> > >regards,
> > >dan carpenter
>
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> https://oss.oracle.com/mailman/listinfo/ocfs2-devel
>
-------------- next part --------------
An HTML attachment was scrubbed...
URL: http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20120815/ffd0b82b/attachment-0001.html 
