From: Vincent ETIENNE <vetienne@aprogsys.com>
Date: Wed, 01 Aug 2012 18:51:00 +0200
Subject: [Ocfs2-devel] kernel BUG at fs/buffer.c:2886! Linux 3.5.0
In-Reply-To: <5016D2C0.6090708@vetienne.net>
References: <501313B6.70801@aprogsys.com>
	<20120730063000.GA4025@dhcp-172-17-9-228.mtv.corp.google.com>
	<50163B8A.7060509@aprogsys.com>
	<20120730075333.GC4025@dhcp-172-17-9-228.mtv.corp.google.com>
	<5016D2C0.6090708@vetienne.net>
Message-ID: <50195E74.6030107@aprogsys.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vincent ETIENNE <ve@vetienne.net>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, ocfs2-devel@oss.oracle.com



Some progress

the fallocate bug is not the only bug
latest head with the fallocate correction still crash
( in read_blocks )

So i have restart bisection but at each stage i reinject the fallocate
patch ( is it a corerct way to do this ?)
Bisection is not very fast but for the moment (sometimes i need to rebot
harsly and it kicks a rebuild of the raid array ) :

git bisect start
# bad: [2d534926205db9ffce4bbbde67cb9b2cee4b835c] Merge tag
'irqdomain-for-linus' of git://git.secretlab.ca/git/linux-2.6
git bisect bad 2d534926205db9ffce4bbbde67cb9b2cee4b835c
# good: [c3b92c8787367a8bb53d57d9789b558f1295cc96] Linux 3.1
git bisect good c3b92c8787367a8bb53d57d9789b558f1295cc96
# good: [95211279c5ad00a317c98221d7e4365e02f20836] Merge branch 'akpm'
(Andrew's patch-bomb)
git bisect good 95211279c5ad00a317c98221d7e4365e02f20836
# good: [654443e20dfc0617231f28a07c96a979ee1a0239] Merge branch
'perf-uprobes-for-linus' of
git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
git bisect good 654443e20dfc0617231f28a07c96a979ee1a0239
# bad: [f0a08fcb5972167e55faa330c4a24fbaa3328b1f] Merge
git://git.kernel.org/pub/scm/linux/kernel/git/cmetcalf/linux-tile
git bisect bad f0a08fcb5972167e55faa330c4a24fbaa3328b1f
# bad: [f5e7e844a571124ffc117d4696787d6afc4fc5ae] Merge tag
'for-linus-3.5-20120601' of git://git.infradead.org/linux-mtd
git bisect bad f5e7e844a571124ffc117d4696787d6afc4fc5ae

Each bad has failed with the read_block OOPS ( so somewhat consistent
for now )




Le 30/07/2012 20:30, Vincent ETIENNE a ?crit :
>
>
> On 30/07/2012 09:53, Joel Becker wrote:
>> On Mon, Jul 30, 2012 at 09:45:14AM +0200, Vincent ETIENNE wrote:
>>> Le 30/07/2012 08:30, Joel Becker a ?crit :
>>>> On Sat, Jul 28, 2012 at 12:18:30AM +0200, Vincent ETIENNE wrote:
>>>>> Hello
>>>>>
>>>>> Get this on first write made ( by deliver sending mail to inform of the
>>>>> restart of services  )
>>>>> Home partition (the one receiving the mail) is based on ocfs2 created
>>>>> from drbd block device in primary/primary mode
>>>>> These drbd devices are based on lvm.
>>>>>
>>>>> system is running linux-3.5.0, identical symptom with linux 3.3 and 3.2
>>>>> but working with linux 3.0 kernel
>>>>>
>>>>> reproduced on two machines ( so different hardware involved on this one
>>>>> software md raid on SATA, on second one areca hardware raid card )
>>>>> but the 2 machines are the one sharing this partition ( so share the
>>>>> same data )
>>>> 	Hmm.  Any chance you can bisect this further?
>>> Will try to. Will take a few days as the server is in production ( but
>>> used as backup so...)
>>>
>>>>> Jul 27 23:41:41 jupiter2 kernel: [  351.169213] ------------[ cut here
>>>>> ]------------
>>>>> Jul 27 23:41:41 jupiter2 kernel: [  351.169261] kernel BUG at
>>>>> fs/buffer.c:2886!
>>>> 	This is:
>>>>
>>>> 	BUG_ON(!buffer_mapped(bh));
>>>>
>>>> in submit_bh().
>>>>
>>>> system_call_fastpath+0x16/0x1b
>>>> 	This stack trace is from 3.5, because of the location of the
>>>> BUG.  The call path in the trace suggests the code added by Al's ea022d,
>>>> but you say it breaks in 3.2 and 3.3 as well.  Can you give me a trace
>>>> from 3.2?
>>> For a 3.2 kernel i get this stack trace. Different trace form 3.5 but
>>> exactly at the same moment. and for the same reasons.
>>> Seems to be less immmediate than with 3.5 but more a subjective
>>> imrpession than something based on fact. ( it takes a few seconds after
>>> deliver is started to have the bug )
>> Totally different stack trace.  Not in symlink code, but instead in
>> fallocate.  Weird.  I wonder if you are hitting two things.  Bisection
>> will definitely help.
> Yes could be, that would explain the 2 stack trace ( and the different
> timing observed )
> Bisection is in progress. The fallocate bug is certainly already
> corrected ( info sent by
> sunil.mushran at gmail.com but unavailable on the list for the moment  ?)
>
> ------
>
> The fallocate() oops is probably the same that is fixed by this patch.
> https://oss.oracle.com/git/?p=smushran/linux-2.6.git;a=commit;h=a2118b301104a24381b414bc93371d666fe8d43a
>
>
> Is in the list of patches that are ready to be pushed.
> https://oss.oracle.com/git/?p=smushran/linux-2.6.git;a=shortlog;h=mw-3.4-mar15
>
> ----
>
> But not sure it will correct all i observed. So i will continue to
> bisect to confirm/infirm.
> ( But i seems to have lost network on my server after a reboot and so no
> more access before tomorrow , I have certainly forget to do make
> modules_install before installing new kernel ... Being stupid is not
> very helpful... ) . I hope to finish the bisection tomorrow or wednesday.
>  
> Thanks a lot for the support.
>> Joel
>>
>>
