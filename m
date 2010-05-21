From: tristan <tristan.ye@oracle.com>
Date: Fri, 21 May 2010 11:05:51 +0800
Subject: [Ocfs2-devel] [PATCH 1/1] Ocfs2: Add new OCFS2_IOC_INFO ioctl
 for ocfs2 v7.
In-Reply-To: <20100521024122.GC9827@mail.oracle.com>
References: <1274236135-5383-1-git-send-email-tristan.ye@oracle.com>
	<20100520232643.GC8335@mail.oracle.com>
	<4BF5E233.9040206@oracle.com>
	<20100521024122.GC9827@mail.oracle.com>
Message-ID: <4BF5F88F.7010203@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Joel Becker wrote:
> On Fri, May 21, 2010 at 09:30:27AM +0800, tristan wrote:
>   
>> Joel Becker wrote:
>>     
>>> 	The specific compile errors I am getting are:
>>>
>>> /build/jlbec/linux-2.6/working/fs/ocfs2/ioctl.c: In function ?ocfs2_info_handle?:
>>> /build/jlbec/linux-2.6/working/fs/ocfs2/ioctl.c:414: error: implicit declaration of function ?compat_ptr?
>>>
>>> and:
>>>
>>>       
>> Joel, thanks for pointing this out, it's a big defect here, I just 
>> tested under ppc/x86_64/i386.
>>
>> Have not tried on ia64 yet... that's totally my mistake...
>>     
>
> 	You're not required to test ia64 specifically.  I got the
> compile error on i386, so I wonder how you did not.
>   

I got error this time as well, I'm afraid I might be testing this before 
I add ocfs2_info_handle to compat_ioctl...





> Joel
>
>   
