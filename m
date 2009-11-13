From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Thu, 12 Nov 2009 18:37:01 -0800
Subject: [Ocfs2-devel] [PATCH 03/18] ocfs2: Handle missing dtor in
	kmem_cache_create()
In-Reply-To: <20091113021753.GA21197@mail.oracle.com>
References: <1258076859-13538-1-git-send-email-sunil.mushran@oracle.com>
	<1258076859-13538-4-git-send-email-sunil.mushran@oracle.com>
	<20091113021753.GA21197@mail.oracle.com>
Message-ID: <4AFCC64D.9040102@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Joel Becker wrote:
> On Thu, Nov 12, 2009 at 05:47:24PM -0800, Sunil Mushran wrote:
>   
>> Mainline commit 20c2df83d25c6a95affe6157a4c9cac4cf5ffaac removed the
>> dtor arg from kmem_cache_create(). Patch adds a kapi macro that adds
>> a dtor arg when building against EL5 kernels.
>>     
>
> 	Question: Do you want to support an assortment of mainline
> kernels, or only "2.6.32" and "2.6.18-el"?  Because there are a number
> of slab things that happened.  I'm not sure which all apply to el5
> anymore.  Not only did the destructor go away, so did the flag
> SLAB_CTOR_VERIFY, and the init_once constructors changed prototype.
> 	Here was my solution:
>
> http://oss.oracle.com/git/oracleasm.git/?p=oracleasm.git;a=commit;h=0888fd1be3d15ab3c7f504c8969c101f7d5d39fd
>
> (Note that there are a couple of later commits to fix typos)
>   

Only EL5 U4. The idea is to be able to able to build against 2.6.32.
But we only support running against EL5 U4.
