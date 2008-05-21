From: Louis Rilling <Louis.Rilling@kerlabs.com>
Date: Wed, 21 May 2008 14:54:34 +0200
Subject: [Ocfs2-devel] [RFC][PATCH 0/3] configfs: Make nested
	default	groups	lockdep-friendly
In-Reply-To: <1211367577.6463.91.camel@lappy.programming.kicks-ass.net>
References: <20080520163320.025971210@kerlabs.com>	
	<20080520095810.1d50d247@infradead.org>	
	<20080520215639.GG26609@mail.oracle.com>	
	<20080520151341.058f2df4@infradead.org>	
	<1211361784.6463.68.camel@lappy.programming.kicks-ass.net>	
	<4833F89F.7080707@kerlabs.com>
	<1211367577.6463.91.camel@lappy.programming.kicks-ass.net>
Message-ID: <48341B8A.1050000@kerlabs.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arjan van de Ven <arjan@infradead.org>, Joel Becker <Joel.Becker@oracle.com>, linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com

Peter Zijlstra a ?crit :
> On Wed, 2008-05-21 at 12:25 +0200, Louis Rilling wrote:
> 
>>> http://programming.kicks-ass.net/kernel-patches/concurrent-pagecache/23-rc1-rt/radix-concurrent-lockdep.patch
>> Thanks for pointing this out.
>>
>> Yes this could solve part of the issue, at the price of duplicating the
>> inode mutex class. However, this still does not solve the issue when
>> deleting config_groups, since in that case all nodes of the tree are
>> locked. Thinking about adding lockdep support for concurrent locking of
>> the direct children of a node in a tree...
> 
> Why doesn't sysfs have this problem? - the code says configfs was
> derived from sysfs.

Perhaps because sysfs is driven from the kernel, where behaviors can be
controlled, while in configfs only userspace creates/removes directories.

> 
> Also, do you really need to hold all locks when removing something?
> sound like a bit overdone. Also realise there is a maximum number of
> held locks - various people have already requested it to be increased or
> made dynamic. We're reluctant in doing so because we feel lock chains
> should not be of unlimited length. The deeper the chains the bigger the
> PI overhead etc..

I did not write configfs, so I can only observe that a whole inode tree
is locked when removing a directory hierarchy. I suspect that this is
intended to provide userspace and client sub-systems with some atomic
semantics...

> 
> As to modifying lockdep - it currently doesn't know about trees and
> teaching it about them isn't easy.

That was my guess.

-- 
Dr Louis Rilling			Kerlabs
Skype: louis.rilling			Batiment Germanium
Phone: (+33|0) 6 80 89 08 23		80 avenue des Buttes de Coesmes
http://www.kerlabs.com/			35700 Rennes
