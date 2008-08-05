From: Tao Ma <tao.ma@oracle.com>
Date: Tue, 05 Aug 2008 12:31:10 +0800
Subject: [Ocfs2-devel] [PATCH 1/1] ocfs2: Add extended attribute support
 v3
In-Reply-To: <20080805035110.GR28014@wotan.suse.de>
References: <20080725215755.GH28014@wotan.suse.de>
	<489187C8.7030708@oracle.com>
	<20080804213404.GO28014@wotan.suse.de>
	<4897BD6B.1060007@oracle.com>
	<20080805035110.GR28014@wotan.suse.de>
Message-ID: <4897D78E.3050101@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Mark,

Mark Fasheh wrote:
> On Tue, Aug 05, 2008 at 10:39:39AM +0800, Tao Ma wrote:
>>>>> Or are you trying to protect xattr against itself? If that's the case, 
>>>>> you
>>>>> could push this lock up to the top and take it around entire operations.
>>>> Actually I am trying to protect xattr read/write by this semaphore,
>>>> since we found a bug about it.
>>>> http://oss.oracle.com/bugzilla/show_bug.cgi?id=990
>>>>
>>>> So I need change comment about xattr semaphore.
>>>> /* protects extended attribute change on this inode */
>>> You could, or how about we just take i_mutex at the top of our xattr
>>> operations for now? If we need the extra performance that more complicated
>>> locking gives us, we can add this later.
>> We can't use i_mutex because of the performance issue. And actually 
>> xattr_sem is done by me at the very beginning and I think it should be 
>> included in Tiger's patch, so asked him to merge it to his patch. ;)
>> I originally used i_mutex in get and list to protect xattr, but as 
>> tristan tested the patch, he told me that the performance is very bad 
>> compared with ext3, so I looked at how ext3 implemented it and there 
>> comes out the usage of xattr_sem.
> 
> Ok, if that's the case then we can certainly keep xattr_sem. I'm curious
> though - what tests are we talking about here?
http://oss.oracle.com/osswiki/OCFS2/XattrTest

btw, tristan.ye from oracle will focus on ocfs2 test in the following 
year. Thank you, tristan.

Regards,
Tao
