From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Wed, 18 May 2011 13:08:36 -0700
Subject: [Ocfs2-devel] [Ocfs2-users] ocfs or configfs bug ?
In-Reply-To: <20110518191150.GB3723@noexit.corp.google.com>
References: <4DADA228.5050209@bull.net> <20110419194840.GA27826@noexit>
	<4DAE26BA.3010203@oracle.com> <4DC9E889.3080008@oracle.com>
	<20110518104955.GA7330@noexit.corp.google.com>
	<20110518111223.GB7330@noexit.corp.google.com>
	<4DD411CB.4090308@oracle.com>
	<20110518191150.GB3723@noexit.corp.google.com>
Message-ID: <4DD42744.1030602@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 05/18/2011 12:11 PM, Joel Becker wrote:
> Oh, over here.
>
> On Wed, May 18, 2011 at 11:36:59AM -0700, Sunil Mushran wrote:
>> On 05/18/2011 04:12 AM, Joel Becker wrote:
>>> On Wed, May 18, 2011 at 03:49:56AM -0700, Joel Becker wrote:
>>>> 	sysfs_mutex is peppered everywhere.  It's rather ugly, I think.
>>>> I am thinking about how the code reads.  I admit I also don't like that
>>>> sysfs_mutex serializes all accesses to the sysfs directory tree, but I'd
>>>> be OK with that as a stopgap solution if the code only read better.
>>> 	Can you test this?
>>>
>>> Joel
>>
>> So it did run for far longer. But then hit the following.
>>
>> http://oss.oracle.com/~smushran/configfs_oops_20110518.txt
> 	I got the same result.
>
>> BTW, this is not new. I was running into it earlier too. Albeit
>> less frequently than readdir.
> 	Do you think this is related, or does my patch fix readdir and
> go upstream with another fix coming for this BUG_ON()?

It does not look directly related. Though it too points to a hole in
the locking. A second patch for this BUG_ON will work.
