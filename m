From: Wengang Wang <wen.gang.wang@oracle.com>
Date: Thu, 29 Apr 2010 17:31:50 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: make lockres lookup faster
In-Reply-To: <4BD86CDB.8030702@oracle.com>
References: <201004281649.o3S3tMKK007057@acsinet15.oracle.com>
	<4BD86CDB.8030702@oracle.com>
Message-ID: <20100429093149.GA3082@laptop.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Sunil,

On 10-04-28 10:14, Sunil Mushran wrote:
> The dlm interface allows different sized locknames. And the locknames can be
> binary. That we use mostly ascii is just coincidental. Yes, mostly.
> The dentry
> lock is partially binary. Also, $RECOVERY is used only during recovery.
> 
> So the only interesting bit from my pov would be:
> 
> -		if (memcmp(res->lockname.name + 1, name + 1, len - 1))
> +		if (memcmp(res->lockname.name, name, len))

Yes, then it's the only bit. 
> Will just this change improve performance? How long a hash list would need
> to be for us to see an appreciable improvement?
I didn't do a test for only this bit, but for the whole change.
For the test I did the test c files are complied with no optimization.

I, just now, tested for only this bit with -O2 optimization, I can _not_ see
improvement for even a 1999999 x 99999 loops of comparation. So please
ignore this patch.

Compiled with no optimization, the comparation is done against each
charator one by one? It's funny.

regards,
wengang.

> Sunil
> 
> 
> Wengang Wang wrote:
> >Lockres lookup is within the dlm->spinlock. We'd better finish the lookup as
> >fast as possible especially when the machine is with more cpus.
> >
> >Existing lookup is comparing charactors starting on a non-aligned address which
> >takes more time. This patch improves the performance mostly by changing comparing
> >on non-aligned address to comparing on aligned address. Also it makes all lockres
> >have same name length so that comparing length is not needed. And thus the extra
> >comparing on the first charactor is not needed any longer.
> >
> >This patch changes recovery lockres name length from 9 to 31. This change doesn't
> >have much badness.
> >
> >Per my test on the loop comparations in user space, This change at most can get
> >15.7% faster.
> >
> >Questions:
> >1. Is there other special lockres name with non-31 length?
> >2. If all lockres name length is changed to 32(including the tailing '\n'), it
> >gets at most 19% faster, but increase 1 byte network transfer for very request.
> >I don't know whether this is worthy.
> >
> >Drawbacks:
> >1. It changes locking version which makes rolling upgrade impossible.
