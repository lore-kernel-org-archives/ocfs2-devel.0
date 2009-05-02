From: Tao Ma <tao.ma@oracle.com>
Date: Sat, 02 May 2009 22:14:28 +0800
Subject: [Ocfs2-devel] [PATCH 17/39] ocfs2: Add ioctl for reflink.
In-Reply-To: <20090501111931.GA29617@mail.oracle.com>
References: <49F95A79.6040806@oracle.com>
	<1241045931-24607-17-git-send-email-tao.ma@oracle.com>
	<20090501073456.GA22000@lst.de>
	<20090501111931.GA29617@mail.oracle.com>
Message-ID: <49FC5544.6070608@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Christoph,
    Joel has told me that we will have a common system call, but I have 
no detail about it yet.

So I just go ahead with my current work. I will change it in my next 
round of patches.

Tao

Joel Becker wrote:
> On Fri, May 01, 2009 at 09:34:56AM +0200, Christoph Hellwig wrote:
>   
>> On Thu, Apr 30, 2009 at 06:58:29AM +0800, Tao Ma wrote:
>>     
>>> The ioctl will take 2 parameters: old_path and new_path and
>>> works like link.
>>>       
>> As discussed during the FS/Storage summit please make this a proper
>> sys_reflink system call and don't add a stupid ioctl.
>>     
>
> Christoph,
> 	Be nice to Tao, I haven't sent him the syscall yet :-)
>
> Joel
>
>   
