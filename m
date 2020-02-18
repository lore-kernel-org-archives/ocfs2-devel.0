From: Joseph Qi <joseph.qi@linux.alibaba.com>
Date: Tue, 18 Feb 2020 18:55:40 +0800
Subject: [Ocfs2-devel] [PATCH 12/44] docs: filesystems: convert
	dlmfs.txt to ReST
In-Reply-To: <20200218110731.2890658d@kernel.org>
References: <cover.1581955849.git.mchehab+huawei@kernel.org>
	<efc9e59925723e17d1a4741b11049616c221463e.1581955849.git.mchehab+huawei@kernel.org>
	<3b40d7d4-3798-08db-220d-b45704ada48a@linux.alibaba.com>
	<20200218110731.2890658d@kernel.org>
Message-ID: <ce80d0cd-a94f-caa8-b8bd-9788afd3927f@linux.alibaba.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Cc: Linux Doc Mailing List <linux-doc@vger.kernel.org>, Jonathan Corbet <corbet@lwn.net>, linux-fsdevel@vger.kernel.org, Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>, ocfs2-devel@oss.oracle.com



On 20/2/18 18:07, Mauro Carvalho Chehab wrote:
> Em Tue, 18 Feb 2020 09:21:51 +0800
> Joseph Qi <joseph.qi@linux.alibaba.com> escreveu:
> 
>> On 20/2/18 00:11, Mauro Carvalho Chehab wrote:
> 
>>> @@ -96,14 +101,19 @@ operation. If the lock succeeds, you'll get an fd.
>>>  open(2) with O_CREAT to ensure the resource inode is created - dlmfs does
>>>  not automatically create inodes for existing lock resources.
>>>  
>>> +============  ===========================
>>>  Open Flag     Lock Request Type
>>> ----------     -----------------  
>>
>> Better to remove the above line.
>>
>>> +============  ===========================
>>>  O_RDONLY      Shared Read
>>>  O_RDWR        Exclusive
>>> +============  ===========================
>>>  
>>> +
>>> +============  ===========================
>>>  Open Flag     Resulting Locking Behavior
>>> ----------     --------------------------  
>>
>> Ditto.
> 
> Ok. So, I guess we can just merge the two tables into one, like:
> 
> 	============  =================
> 	O_RDONLY      Shared Read
> 	O_RDWR        Exclusive
> 	O_NONBLOCK    Trylock operation
> 	============  =================
> 
> Right?
> 
I think they should be in different section.
The first two are lock level, while the last is lock behavior.

Thanks,
Joseph
