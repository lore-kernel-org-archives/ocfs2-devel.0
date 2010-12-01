From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Tue, 30 Nov 2010 22:24:15 -0800
Subject: [Ocfs2-devel] [PATCH] ocfs2/dlm: queue ast in lockres->spinlock
In-Reply-To: <20101201061614.GA5352@laptop.jp.oracle.com>
References: <201011301551.oAUD3n5c002863@rcsinet13.oracle.com>
	<4CF54F55.8080007@oracle.com>
	<20101201025218.GA3709@laptop.jp.oracle.com>
	<4CF5DE2C.2090807@oracle.com>
	<20101201061614.GA5352@laptop.jp.oracle.com>
Message-ID: <FA41024B-80D6-4CDC-8DBB-B58772C26182@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com



On Nov 30, 2010, at 10:16 PM, Wengang Wang <wen.gang.wang@oracle.com> wrote:

> On 10-11-30 21:33, Sunil Mushran wrote:
>> On 11/30/2010 06:52 PM, Wengang Wang wrote:
>>> First I have to say that the scenario is in my thought only, no tcpdump
>>> shows that. Only the node C wanting a PR is the truth from the vmcore.
>>> 
>>> Let's consider this situation:
>>> 
>>> The create lock(CL) is for a PR;
>>> the up convert(UC) is PR->EX;
>>> there is an existing PR granted for another node(say node D) before the UC comes
>>> 
>>> The UC comes. Because of the existing PR, the UC lock is moved to converting list.
>>> dlm_thread takes care it later.
>>> The CL comes. no conflict found(see dlm_can_grant_new_lock, convert_type not
>>> checked there). so it's not added to blocked list.
>>> 
>>> Seems the above scenario can trigger a BAST before AST.
>> 
>> dlm_can_grant_new_lock() should be looking at convert_type also and
>> add the lock to the blocked list in this case.
>> 
>> This is not just to plug this hole but is as per the spec.
> So you meant o2dlm is (should be) implementing fair locking? Anywhere I
> can take a look at the spec?
> 

Google for Programming Locking Applications by Kristin Thomas. Or, grep the same in the source. The link is there. 
