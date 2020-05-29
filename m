From: Eric W. Biederman <ebiederm@xmission.com>
Date: Fri, 29 May 2020 07:42:31 -0500
Subject: [Ocfs2-devel] [PATCH 01/13] sysctl: add new
	register_sysctl_subdir() helper
In-Reply-To: <87ftbiud6s.fsf@x220.int.ebiederm.org> (Eric W. Biederman's
	message of "Fri, 29 May 2020 07:40:27 -0500")
References: <20200529074108.16928-1-mcgrof@kernel.org>
	<20200529074108.16928-2-mcgrof@kernel.org>
	<87ftbiud6s.fsf@x220.int.ebiederm.org>
Message-ID: <878shaud3c.fsf@x220.int.ebiederm.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Luis Chamberlain <mcgrof@kernel.org>
Cc: jack@suse.cz, rafael@kernel.org, airlied@linux.ie, benh@kernel.crashing.org, amir73il@gmail.com, clemens@ladisch.de, dri-devel@lists.freedesktop.org, joseph.qi@linux.alibaba.com, sfr@canb.auug.org.au, mark@fasheh.com, rdna@fb.com, yzaikin@google.com, keescook@chromium.org, arnd@arndb.de, intel-gfx@lists.freedesktop.org, julia.lawall@lip6.fr, viro@zeniv.linux.org.uk, nixiaoming@huawei.com, vbabka@suse.cz, axboe@kernel.dk, tytso@mit.edu, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, akpm@linux-foundation.org, linuxppc-dev@lists.ozlabs.org, ocfs2-devel@oss.oracle.com, jlbec@evilplan.org

ebiederm at xmission.com (Eric W. Biederman) writes:

> Luis Chamberlain <mcgrof@kernel.org> writes:
>
>> Often enough all we need to do is create a subdirectory so that
>> we can stuff sysctls underneath it. However, *if* that directory
>> was already created early on the boot sequence we really have no
>> need to use the full boiler plate code for it, we can just use
>> local variables to help us guide sysctl to place the new leaf files.
>>
>> So use a helper to do precisely this.
>
> Reset restart.  This is patch is total nonsense.
>
> - You are using register_sysctl_table which as I believe I have
>   mentioned is a deprecated compatibility wrapper.  The point of
>   spring house cleaning is to get off of the deprecated functions
>   isn't it?
>
> - You are using the old nasty form for creating directories instead
>   of just passing in a path.
>
> - None of this is even remotely necessary.  The directories
>   are created automatically if you just register their entries.

Oh.  *blink*  The poor naming threw me off.

This is a clumsy and poorly named version of register_sysctl();

Yes. This change is totally unnecessary.

Eric
