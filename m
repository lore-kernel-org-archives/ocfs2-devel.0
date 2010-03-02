From: tristan <tristan.ye@oracle.com>
Date: Tue, 02 Mar 2010 11:13:22 +0800
Subject: [Ocfs2-devel] [PATCH 1/2] Ocfs2: Move ocfs2 ioctl definitions
 from ocfs2_fs.h to new added ocfs2_ioctl.h.
In-Reply-To: <20100302023217.GD447@mail.oracle.com>
References: <1266997872-17091-1-git-send-email-tiger.yang@oracle.com>
	<20100302012121.GC447@mail.oracle.com>
	<4B8C7304.8070108@oracle.com>
	<20100302023217.GD447@mail.oracle.com>
Message-ID: <4B8C8252.1060507@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Joel Becker wrote:
> On Tue, Mar 02, 2010 at 10:08:04AM +0800, tristan wrote:
>   
>> Currently 'resize.h' and 'file.h' are using ioctl structures from
>> 'ocfs2_ioctl.h', don't like 'resize.h', which only was included in
>> 'resize.c', 'file.h' instead was referred everywhere:
>>
>> We therefore need to add 'ocfs2_ioctl.h' in many C sources to avoid
>> compile warnings.
>>     
>
> 	That's right, you put it in the C sources.  This way we know
> what includes each C file has, and only the C files needing the include
> file actually include it.
>   

I'm fine with this:)

BTW, it's a bad idea to add ocfs2_ioctl.h to ocfs2.h? it's not generic 
enough to be there to let every C file refer it? right?


Tristan.


> Joel
>
>   
