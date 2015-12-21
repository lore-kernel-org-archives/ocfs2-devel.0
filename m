From: Eric Ren <zren@suse.com>
Date: Mon, 21 Dec 2015 19:23:35 +0800
Subject: [Ocfs2-devel] The root cause analysis about buffer read getting
 starvation
In-Reply-To: <20151218232846.GN11072@wotan.suse.de>
References: <56736AAA020000F9001A9EEA@relay2.provo.novell.com>
	<20151218090939.GB10744@desktop.lab.bej.apac.novell.com>
	<20151218232846.GN11072@wotan.suse.de>
Message-ID: <20151221112335.GC3454@laptop.ha>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hello Mark,

...snip..
> > SLES10 with kernel version about 2.6.16.x, used blocking way, i.e. down_read(), wich has the
> > potential deaklock between page lock / ip_alloc_sem when one node get the cluster lock and
> > does writing and reading on same file on it. This deadlock was fixed by this commit:
> 
> You are correct here - the change was introduced to solve a deadlock between
> page lock and ip_alloc_sem(). Basically, ->readpage is going to be called
> with the page lock held and we need to be aware of that.
...snip..
> > But somehow with this patch, performance in the scenario become very bad. I don't how this could happen? because the reading node just has only one
> > thread reading the shared file, then down_read_trylock() should always get ip_alloc_sem successfully, right? if not, who else may race ip_alloc_sem?
> 
> Hmm, there's only one thread and it can't get the lock? Any chance you might
No, it can always get the lock in this case. Sorry, I made a false testing
result. There're probably mainly two factors:

1. none-isolated testing environment - include nodes, network and shared disk;
2. testing program from customer - sleep for 1s after finishing ~1M read/write each time,
   thus the overlap time of read/write on two nodes is random; so the shoter overlap time is,
   the better performance looks.
   
Sorry again for bothering your time.
--Eric
> put some debug prints around where we acquire ip_alloc_sem? It would be
> interesting to see where it get taken to prevent this from happening.
> 	--Mark
> 
> --
> Mark Fasheh
> 
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> https://oss.oracle.com/mailman/listinfo/ocfs2-devel
> 
