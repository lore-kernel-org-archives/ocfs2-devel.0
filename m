From: Michael Steinmann <msl@calivia.com>
Date: Thu Oct 27 05:37:21 2005
Subject: [Ocfs2-devel] Support for SLES9
In-Reply-To: <20051025155427.GA18070@marowsky-bree.de>
References: <15538.193.5.216.100.1130229159.squirrel@www2.calivia.com>
	<20051025155427.GA18070@marowsky-bree.de>
Message-ID: <50009.193.5.216.100.1130409494.squirrel@www2.calivia.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

>> Support for SLES9 seems to be pretty much lacking at the moment.
>
> This is not true, hopefully.

OK, finally got it to work with the YOU kernel update.

>> The OCFS2 site [1] states OCFS2 is supported with SP2+. There actually
>> does not exist a SP2+ for SLES9 (or should this rather read "will be
>> supported in SP3" instead?).
>
> It measn "SP2 and up".

I believe it would make non-suse insiders life _a lot_ easier to just say
that one actually needs SLES9 SP2 + YOU updates (>=kernel-2.6.5-7.201).

Unless you want customers to ask Novell support for the non-existant SP2+.


>> Latest RPMs that come with SLES9 SP2 are 0.99.14 which has critical
>> known
>> bugs and is unusable.
>
> The in-kernel version is much higher, which is where the critical bugs
> have been fixed.
>
> A later user-space version has not been deemed necessary yet; if you
> have a support contract and require it, please file a request.

same as above

>> Anybody got to compile current source on SLES9 x86_64?
>> 1.1.2, 1.1.6 and trunk all fail to compile on SLES9.SP2
>> 2.6.5-7.191-smp SMP x86_64 [3].
>
> SP2 only officially supports OCFS2 1.0.x.
>
> We will include 1.1/1.2 in SP3.
>
>> Problem here is that we loose IP heartbeat and node1 fences shortly
>> after
>> mounting a shared LV on the second node [4]. Bummer.
>
> Please file a support request with Novell.

works now with the new kernel with ocfs2-1.0.2

> Sincerely,
>     Lars Marowsky-Br?e <lmb@suse.de>
>
> --
> High Availability & Clustering
> SUSE Labs, Research and Development
> SUSE LINUX Products GmbH - A Novell Business	 -- Charles Darwin
> "Ignorance more frequently begets confidence than does knowledge"
