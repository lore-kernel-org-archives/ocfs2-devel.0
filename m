From: tristan <tristan.ye@oracle.com>
Date: Tue, 09 Feb 2010 09:19:11 +0800
Subject: [Ocfs2-devel] [PATCH 2/3] Ocfs2: Change
 ocfs2_prepare_refcount_change_for_del() a bit to defer blocks reservation.
In-Reply-To: <20100209005916.GH1832@mail.oracle.com>
References: <1264591326-24591-1-git-send-email-tristan.ye@oracle.com>
	<1264591326-24591-2-git-send-email-tristan.ye@oracle.com>
	<4B60BB4A.3030008@oracle.com> <4B60E84C.6060800@oracle.com>
	<20100209005916.GH1832@mail.oracle.com>
Message-ID: <4B70B80F.8000101@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Joel Becker wrote:
> On Thu, Jan 28, 2010 at 09:28:44AM +0800, tristan wrote:
>   
>> TaoMa wrote:
>>     
>>> Hi Tristan,
>>>    you'd better integrate this patch with patch 3/3. otherwise we 
>>> can't build successfully if we apply this one and don't apply the next 
>>> one(in some git bisect case).
>>>       
>> Yes I see, here I just split the patches as small as possible to be 
>> logically separate,  for the convenience of your reviewing:)
>>     
>
> Tristan,
> 	Your instinct is good, but Tao is right, every commit has to
> compile and work.  The next patches you work on, keep trying to break it
> up into logical things, but have working code.  One of the best tricks
> is doing the isomorphic changes (changes that don't actually affect the
> behavior yet) first.  I use this trick a lot.  I can add an argument to
> a function or change what is passed through without actually changing
> the functionality.  Once I've used this methodology to restructure the
> code, then I can change the behavior.
>   

Joel, tao,

Your help really makes sense, thank you guys for sharing the experience:)


Tristan.


> 	For this particular change, I'm OK with it being one patch as I
> stated in my other email.
>
> Joel
>
>   
