Received: from valentin-vidic.from.hr (valentin-vidic.from.hr [116.203.65.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3DEF69957;
	Tue, 12 Mar 2024 08:09:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=116.203.65.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710231005; cv=none; b=aFV+RhjHPinyvCm8uljggT7Z9B92W8SuNsRnXMrFcGapMqm5KOkXPdSnbmB+gL0o2l2y1kJ789zcuq9rljOTBME2HkosuI2Y1lys/IUUD97+Y/SIqb7o2/CfCSOUS3lvGk/d/wQg50Ke0daOXgaOX0BLNhRNvrnMqnuw9eNeEEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710231005; c=relaxed/simple;
	bh=Ot6ywGg4//WanuSCtUfB+9EoRgBaR+9+Tgdp4d9jhKU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kZ6hb92T7ykh4rFEFU/iPUyt0C4z6tI8YBtblKkLwY5vtggp9Jnmt2o9DBn3U12GTqo18u9p9OGD4wlUYIsecvJPAajOXdfG1mDBpjDKZU0GOBh0tQ524tBz/KSvDV2Co9U2mpdJaWhp7qAR4f/pbJCqXmeUVf8xmx337pnVVcQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=valentin-vidic.from.hr; spf=pass smtp.mailfrom=valentin-vidic.from.hr; dkim=pass (4096-bit key) header.d=valentin-vidic.from.hr header.i=@valentin-vidic.from.hr header.b=zqUTJNB/; arc=none smtp.client-ip=116.203.65.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=valentin-vidic.from.hr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=valentin-vidic.from.hr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=valentin-vidic.from.hr header.i=@valentin-vidic.from.hr header.b="zqUTJNB/"
X-Virus-Scanned: Debian amavis at valentin-vidic.from.hr
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
	d=valentin-vidic.from.hr; s=2020; t=1710230984;
	bh=Ot6ywGg4//WanuSCtUfB+9EoRgBaR+9+Tgdp4d9jhKU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=zqUTJNB/e+Jg/Fn/kU8dI69h6PlXuiviBPEY4NDyH3hmDnoRKWmjenkJ9ssrQ6BoO
	 1bum1zswnEdkop8JV3seyzSbeRUR5GSZKqu2c4FxlYozJydjVzA9KB4QYQsu7L1g8S
	 hC/U9FZy7nblBK7I347lP8D+pPxDqeD9N2jXxG4orXAvvN4/5FWGL0mUOgpL/m0iAu
	 LKa2lTpypKcmduEpEdAGGQvModR+1nxNfDPGr4CeQMm98Ft0P+dW0apYRu9Yw4fj/l
	 9dLQqTlqYJFI8Z97jXU7xhjwVelthWz8nbpwEfC+mULmzR8Q6q+T58KjV/xEHXANm6
	 HFhhc2plKQLB+v6N5kwXniQlhHP+UG2BnjB/l42YqLb/V98LVEi2r6MFMPZlDvCqP6
	 omjWu2uPDGc+jbHpSQHuOyw+fwmMUoRcJAqf7ijNzhuk6KKUGB10xQrUodzQrcL0Qn
	 Vch2X03hevz+ElWBFPiVqC8u7gksWRJfbZnvzox1Vht4/rSbFDrrdFfwhTlX7KVE6P
	 /yeEpL7FSMYbmNwN0MME26eT4Cre7BAELe7sgTp6Xh/AF5kfgvAqutvhBcc6ZxaL3Z
	 cJtpW2U9ANDqNv+Y7LCephTX6zTS2iNJgL/E35cjiqx054Nxua08vzUOgpaOvwvKn6
	 IPk6z6cu9bfAT+GgFIs52mOE=
Received: by valentin-vidic.from.hr (Postfix, from userid 1000)
	id 9F5802D2C5; Tue, 12 Mar 2024 09:09:44 +0100 (CET)
Date: Tue, 12 Mar 2024 09:09:44 +0100
From: Valentin =?utf-8?B?VmlkacSH?= <vvidic@valentin-vidic.from.hr>
To: Alexander Aring <aahringo@redhat.com>
Cc: Joseph Qi <joseph.qi@linux.alibaba.com>, ocfs2-devel@oss.oracle.com,
	David Teigland <teigland@redhat.com>, gfs2@lists.linux.dev,
	ocfs2-devel@lists.linux.dev
Subject: Re: ocfs2 mount error
Message-ID: <ZfANyOkQh4SgXoty@valentin-vidic.from.hr>
References: <Ze4qSvzGJDt5yxC3@valentin-vidic.from.hr>
 <49396145-712d-44eb-884e-58eb19b1f4f2@linux.alibaba.com>
 <Ze7IiZmlhRaOgdhm@valentin-vidic.from.hr>
 <CAK-6q+jFv8tK4rF-xY6okTwhK87zMtOKP6fthzCQ-H8-4q=wbQ@mail.gmail.com>
 <Ze9bIiT3rAWTtPJp@valentin-vidic.from.hr>
 <CAK-6q+j2UDh0mi0KUTdtsRE8pj4+tuw_SU+yjzjsR3GCLURz=w@mail.gmail.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="9Kt8mU6uY+Ra0oRv"
Content-Disposition: inline
In-Reply-To: <CAK-6q+j2UDh0mi0KUTdtsRE8pj4+tuw_SU+yjzjsR3GCLURz=w@mail.gmail.com>


--9Kt8mU6uY+Ra0oRv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Mar 11, 2024 at 07:43:41PM -0400, Alexander Aring wrote:
> I step forward here, but still I am not able to set a cluster name. I
> hardcoded it in the kernel and "it seems" to work. How do you set the
> cluster name? It seems that setting the cluster name in mkfs is not
> the way to go.

I think the cluster name comes from corosync, here is the config I have
there:

totem {
	version: 2
	cluster_name: debian
	crypto_cipher: none
	crypto_hash: none
}
logging {
	fileline: off
	to_stderr: yes
	to_logfile: yes
	logfile: /var/log/corosync/corosync.log
	to_syslog: yes
	debug: off
	logger_subsys {
		subsys: QUORUM
		debug: off
	}
}
quorum {
	provider: corosync_votequorum
}
nodelist {
	node {
		name: node1
		nodeid: 1
		ring0_addr: 127.0.0.1
	}
}

The status of the services is as follows:

# corosync-quorumtool 
Quorum information
------------------
Date:             Tue Mar 12 07:49:18 2024
Quorum provider:  corosync_votequorum
Nodes:            1
Node ID:          1
Ring ID:          1.5
Quorate:          Yes

Votequorum information
----------------------
Expected votes:   1
Highest expected: 1
Total votes:      1
Quorum:           1  
Flags:            Quorate 

Membership information
----------------------
    Nodeid      Votes Name
         1          1 node1 (local)

# dlm_tool dump_config
daemon_debug=0
foreground=1 (cli option)
log_debug=0
protocol=detect
port=21064
debug_logfile=0
bind_all=0
mark=0
enable_fscontrol=0
enable_plock=1
plock_debug=0
plock_rate_limit=0
plock_ownership=0
drop_resources_time=10000
drop_resources_count=10
drop_resources_age=10000
post_join_delay=30
enable_fencing=1
enable_concurrent_fencing=0
enable_startup_fencing=1
repeat_failed_fencing=1
enable_quorum_fencing=1
enable_quorum_lockspace=1
enable_helper=1
help=-1
version=-1

> I am able to run fsck and I see on "dlm_tool ls" a lockspace with a
> similar name you have.
> 
> The bad news is, I can't reproduce it. After fsck the lockspace
> releases successfully.
> 
> I see on your debug information that it uses dlm user space locks, in
> my case I am using dlm kernel locks and I am asking myself why. Can
> you tell me more about your cluster configuration?
> 
> Somehow in your case fsck is using the DLM user space locks
> functionality from libdlm (the user space DLM locking library) but in
> my case fsck goes over the ocfs2_fsdlm filesystem and then does DLM
> kernel locks.
> I am asking myself how this is supposed to work.

I'm attaching the strace from fsck below, but it could be that ocfs2_dlmfs
module is not loaded, so it falls back to user space locks?

-- 
Valentin

--9Kt8mU6uY+Ra0oRv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="fsck.1654"

execve("/usr/sbin/fsck.ocfs2", ["fsck.ocfs2", "-f", "-y", "/dev/loop0"], 0x7fff21dd7108 /* 27 vars */) = 0
brk(NULL)                               = 0x563054c7d000
access("/etc/ld.so.preload", R_OK)      = -1 ENOENT (No such file or directory)
openat(AT_FDCWD, "/etc/ld.so.cache", O_RDONLY|O_CLOEXEC) = 3
newfstatat(3, "", {st_mode=S_IFREG|0644, st_size=13065, ...}, AT_EMPTY_PATH) = 0
mmap(NULL, 13065, PROT_READ, MAP_PRIVATE, 3, 0) = 0x7f61b3401000
close(3)                                = 0
mmap(NULL, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f61b33ff000
openat(AT_FDCWD, "/lib/x86_64-linux-gnu/libdlm_lt.so.3", O_RDONLY|O_CLOEXEC) = 3
read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0\0\0\0\0\0\0\0\0"..., 832) = 832
newfstatat(3, "", {st_mode=S_IFREG|0644, st_size=18424, ...}, AT_EMPTY_PATH) = 0
mmap(NULL, 20536, PROT_READ, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7f61b33f9000
mmap(0x7f61b33fa000, 8192, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x1000) = 0x7f61b33fa000
mmap(0x7f61b33fc000, 4096, PROT_READ, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x3000) = 0x7f61b33fc000
mmap(0x7f61b33fd000, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x3000) = 0x7f61b33fd000
close(3)                                = 0
openat(AT_FDCWD, "/lib/x86_64-linux-gnu/libcmap.so.4", O_RDONLY|O_CLOEXEC) = 3
read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0\0\0\0\0\0\0\0\0"..., 832) = 832
newfstatat(3, "", {st_mode=S_IFREG|0644, st_size=26672, ...}, AT_EMPTY_PATH) = 0
mmap(NULL, 28816, PROT_READ, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7f61b33f1000
mmap(0x7f61b33f3000, 12288, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x2000) = 0x7f61b33f3000
mmap(0x7f61b33f6000, 4096, PROT_READ, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x5000) = 0x7f61b33f6000
mmap(0x7f61b33f7000, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x5000) = 0x7f61b33f7000
close(3)                                = 0
openat(AT_FDCWD, "/lib/x86_64-linux-gnu/libcom_err.so.2", O_RDONLY|O_CLOEXEC) = 3
read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0\0\0\0\0\0\0\0\0"..., 832) = 832
newfstatat(3, "", {st_mode=S_IFREG|0644, st_size=18344, ...}, AT_EMPTY_PATH) = 0
mmap(NULL, 20552, PROT_READ, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7f61b33eb000
mmap(0x7f61b33ed000, 4096, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x2000) = 0x7f61b33ed000
mmap(0x7f61b33ee000, 4096, PROT_READ, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x3000) = 0x7f61b33ee000
mmap(0x7f61b33ef000, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x3000) = 0x7f61b33ef000
close(3)                                = 0
openat(AT_FDCWD, "/lib/x86_64-linux-gnu/libaio.so.1t64", O_RDONLY|O_CLOEXEC) = 3
read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0\0\0\0\0\0\0\0\0"..., 832) = 832
newfstatat(3, "", {st_mode=S_IFREG|0644, st_size=14184, ...}, AT_EMPTY_PATH) = 0
mmap(NULL, 16432, PROT_READ, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7f61b33e6000
mmap(0x7f61b33e7000, 4096, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x1000) = 0x7f61b33e7000
mmap(0x7f61b33e8000, 4096, PROT_READ, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x2000) = 0x7f61b33e8000
mmap(0x7f61b33e9000, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x2000) = 0x7f61b33e9000
close(3)                                = 0
openat(AT_FDCWD, "/lib/x86_64-linux-gnu/libc.so.6", O_RDONLY|O_CLOEXEC) = 3
read(3, "\177ELF\2\1\1\3\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0\220x\2\0\0\0\0\0"..., 832) = 832
pread64(3, "\6\0\0\0\4\0\0\0@\0\0\0\0\0\0\0@\0\0\0\0\0\0\0@\0\0\0\0\0\0\0"..., 784, 64) = 784
newfstatat(3, "", {st_mode=S_IFREG|0755, st_size=1926256, ...}, AT_EMPTY_PATH) = 0
pread64(3, "\6\0\0\0\4\0\0\0@\0\0\0\0\0\0\0@\0\0\0\0\0\0\0@\0\0\0\0\0\0\0"..., 784, 64) = 784
mmap(NULL, 1974096, PROT_READ, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7f61b3204000
mmap(0x7f61b322a000, 1396736, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x26000) = 0x7f61b322a000
mmap(0x7f61b337f000, 344064, PROT_READ, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x17b000) = 0x7f61b337f000
mmap(0x7f61b33d3000, 24576, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x1cf000) = 0x7f61b33d3000
mmap(0x7f61b33d9000, 53072, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x7f61b33d9000
close(3)                                = 0
openat(AT_FDCWD, "/lib/x86_64-linux-gnu/libcorosync_common.so.4", O_RDONLY|O_CLOEXEC) = 3
read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0\0\0\0\0\0\0\0\0"..., 832) = 832
newfstatat(3, "", {st_mode=S_IFREG|0644, st_size=13952, ...}, AT_EMPTY_PATH) = 0
mmap(NULL, 16400, PROT_READ, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7f61b31ff000
mmap(0x7f61b3200000, 4096, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x1000) = 0x7f61b3200000
mmap(0x7f61b3201000, 4096, PROT_READ, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x2000) = 0x7f61b3201000
mmap(0x7f61b3202000, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x2000) = 0x7f61b3202000
close(3)                                = 0
openat(AT_FDCWD, "/lib/x86_64-linux-gnu/libqb.so.100", O_RDONLY|O_CLOEXEC) = 3
read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0\0\0\0\0\0\0\0\0"..., 832) = 832
newfstatat(3, "", {st_mode=S_IFREG|0644, st_size=165872, ...}, AT_EMPTY_PATH) = 0
mmap(NULL, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f61b31fd000
mmap(NULL, 430816, PROT_READ, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7f61b3193000
mmap(0x7f61b319a000, 94208, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x7000) = 0x7f61b319a000
mmap(0x7f61b31b1000, 36864, PROT_READ, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x1e000) = 0x7f61b31b1000
mmap(0x7f61b31ba000, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x27000) = 0x7f61b31ba000
mmap(0x7f61b31bc000, 262880, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x7f61b31bc000
close(3)                                = 0
openat(AT_FDCWD, "/lib/x86_64-linux-gnu/libsystemd.so.0", O_RDONLY|O_CLOEXEC) = 3
read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0\0\0\0\0\0\0\0\0"..., 832) = 832
newfstatat(3, "", {st_mode=S_IFREG|0644, st_size=918624, ...}, AT_EMPTY_PATH) = 0
mmap(NULL, 923208, PROT_READ, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7f61b30b1000
mmap(0x7f61b30c8000, 573440, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x17000) = 0x7f61b30c8000
mmap(0x7f61b3154000, 200704, PROT_READ, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0xa3000) = 0x7f61b3154000
mmap(0x7f61b3185000, 53248, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0xd3000) = 0x7f61b3185000
mmap(0x7f61b3192000, 1608, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x7f61b3192000
close(3)                                = 0
openat(AT_FDCWD, "/lib/x86_64-linux-gnu/libcap.so.2", O_RDONLY|O_CLOEXEC) = 3
read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0\200w\0\0\0\0\0\0"..., 832) = 832
newfstatat(3, "", {st_mode=S_IFREG|0644, st_size=47288, ...}, AT_EMPTY_PATH) = 0
mmap(NULL, 45128, PROT_READ, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7f61b30a5000
mmap(0x7f61b30a8000, 20480, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x3000) = 0x7f61b30a8000
mmap(0x7f61b30ad000, 8192, PROT_READ, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x8000) = 0x7f61b30ad000
mmap(0x7f61b30af000, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0xa000) = 0x7f61b30af000
close(3)                                = 0
openat(AT_FDCWD, "/lib/x86_64-linux-gnu/libgcrypt.so.20", O_RDONLY|O_CLOEXEC) = 3
read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0\0\0\0\0\0\0\0\0"..., 832) = 832
newfstatat(3, "", {st_mode=S_IFREG|0644, st_size=1336728, ...}, AT_EMPTY_PATH) = 0
mmap(NULL, 1340360, PROT_READ, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7f61b2f5d000
mmap(0x7f61b2f6c000, 966656, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0xf000) = 0x7f61b2f6c000
mmap(0x7f61b3058000, 274432, PROT_READ, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0xfb000) = 0x7f61b3058000
mmap(0x7f61b309b000, 36864, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x13d000) = 0x7f61b309b000
mmap(0x7f61b30a4000, 968, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x7f61b30a4000
close(3)                                = 0
openat(AT_FDCWD, "/lib/x86_64-linux-gnu/liblz4.so.1", O_RDONLY|O_CLOEXEC) = 3
read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0\0\0\0\0\0\0\0\0"..., 832) = 832
newfstatat(3, "", {st_mode=S_IFREG|0644, st_size=149952, ...}, AT_EMPTY_PATH) = 0
mmap(NULL, 152032, PROT_READ, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7f61b2f37000
mmap(0x7f61b2f3a000, 122880, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x3000) = 0x7f61b2f3a000
mmap(0x7f61b2f58000, 12288, PROT_READ, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x21000) = 0x7f61b2f58000
mmap(0x7f61b2f5b000, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x23000) = 0x7f61b2f5b000
close(3)                                = 0
openat(AT_FDCWD, "/lib/x86_64-linux-gnu/liblzma.so.5", O_RDONLY|O_CLOEXEC) = 3
read(3, "\177ELF\2\1\1\3\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0\0\0\0\0\0\0\0\0"..., 832) = 832
newfstatat(3, "", {st_mode=S_IFREG|0644, st_size=247800, ...}, AT_EMPTY_PATH) = 0
mmap(NULL, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f61b2f35000
mmap(NULL, 245800, PROT_READ, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7f61b2ef8000
mmap(0x7f61b2efc000, 167936, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x4000) = 0x7f61b2efc000
mmap(0x7f61b2f25000, 57344, PROT_READ, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x2d000) = 0x7f61b2f25000
mmap(0x7f61b2f33000, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x3b000) = 0x7f61b2f33000
close(3)                                = 0
openat(AT_FDCWD, "/lib/x86_64-linux-gnu/libzstd.so.1", O_RDONLY|O_CLOEXEC) = 3
read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0\0\0\0\0\0\0\0\0"..., 832) = 832
newfstatat(3, "", {st_mode=S_IFREG|0644, st_size=784376, ...}, AT_EMPTY_PATH) = 0
mmap(NULL, 786496, PROT_READ, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7f61b2e37000
mmap(0x7f61b2e3c000, 679936, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x5000) = 0x7f61b2e3c000
mmap(0x7f61b2ee2000, 81920, PROT_READ, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0xab000) = 0x7f61b2ee2000
mmap(0x7f61b2ef6000, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0xbe000) = 0x7f61b2ef6000
close(3)                                = 0
openat(AT_FDCWD, "/lib/x86_64-linux-gnu/libgpg-error.so.0", O_RDONLY|O_CLOEXEC) = 3
read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0\0\0\0\0\0\0\0\0"..., 832) = 832
newfstatat(3, "", {st_mode=S_IFREG|0644, st_size=161864, ...}, AT_EMPTY_PATH) = 0
mmap(NULL, 164304, PROT_READ, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7f61b2e0e000
mmap(0x7f61b2e13000, 94208, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x5000) = 0x7f61b2e13000
mmap(0x7f61b2e2a000, 45056, PROT_READ, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x1c000) = 0x7f61b2e2a000
mmap(0x7f61b2e35000, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x26000) = 0x7f61b2e35000
close(3)                                = 0
mmap(NULL, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f61b2e0c000
mmap(NULL, 12288, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f61b2e09000
arch_prctl(ARCH_SET_FS, 0x7f61b2e09800) = 0
set_tid_address(0x7f61b2e09ad0)         = 1654
set_robust_list(0x7f61b2e09ae0, 24)     = 0
rseq(0x7f61b2e0a120, 0x20, 0, 0x53053053) = 0
mprotect(0x7f61b33d3000, 16384, PROT_READ) = 0
mprotect(0x7f61b2e35000, 4096, PROT_READ) = 0
mprotect(0x7f61b2ef6000, 4096, PROT_READ) = 0
mprotect(0x7f61b2f33000, 4096, PROT_READ) = 0
mprotect(0x7f61b2f5b000, 4096, PROT_READ) = 0
mprotect(0x7f61b309b000, 20480, PROT_READ) = 0
mprotect(0x7f61b30af000, 4096, PROT_READ) = 0
mprotect(0x7f61b3185000, 49152, PROT_READ) = 0
mprotect(0x7f61b31ba000, 4096, PROT_READ) = 0
mprotect(0x7f61b3202000, 4096, PROT_READ) = 0
mprotect(0x7f61b33e9000, 4096, PROT_READ) = 0
mprotect(0x7f61b33ef000, 4096, PROT_READ) = 0
mprotect(0x7f61b33f7000, 4096, PROT_READ) = 0
mprotect(0x7f61b33fd000, 4096, PROT_READ) = 0
mprotect(0x563052eed000, 4096, PROT_READ) = 0
mprotect(0x7f61b3435000, 8192, PROT_READ) = 0
prlimit64(0, RLIMIT_STACK, NULL, {rlim_cur=8192*1024, rlim_max=RLIM64_INFINITY}) = 0
munmap(0x7f61b3401000, 13065)           = 0
getrandom("\xb3\xf1\xb9\xa1\x5c\xd8\xbe\xe2", 8, GRND_NONBLOCK) = 8
brk(NULL)                               = 0x563054c7d000
brk(0x563054c9e000)                     = 0x563054c9e000
prctl(PR_CAPBSET_READ, CAP_MAC_OVERRIDE) = 1
prctl(PR_CAPBSET_READ, 0x30 /* CAP_??? */) = -1 EINVAL (Invalid argument)
prctl(PR_CAPBSET_READ, CAP_CHECKPOINT_RESTORE) = 1
prctl(PR_CAPBSET_READ, 0x2c /* CAP_??? */) = -1 EINVAL (Invalid argument)
prctl(PR_CAPBSET_READ, 0x2a /* CAP_??? */) = -1 EINVAL (Invalid argument)
prctl(PR_CAPBSET_READ, 0x29 /* CAP_??? */) = -1 EINVAL (Invalid argument)
newfstatat(2, "", {st_mode=S_IFIFO|0644, st_size=0, ...}, AT_EMPTY_PATH) = 0
write(2, "fsck.ocfs2 1.8.8\n", 17)      = 17
newfstatat(AT_FDCWD, "/dev/loop0", {st_mode=S_IFBLK|0660, st_rdev=makedev(0x7, 0), ...}, 0) = 0
openat(AT_FDCWD, "/proc/swaps", O_RDONLY) = 3
newfstatat(3, "", {st_mode=S_IFREG|0444, st_size=0, ...}, AT_EMPTY_PATH) = 0
read(3, "Filename\t\t\t\tType\t\tSize\t\tUsed\t\tPr"..., 1024) = 39
read(3, "", 1024)                       = 0
close(3)                                = 0
openat(AT_FDCWD, "/proc/mounts", O_RDONLY|O_CLOEXEC) = 3
newfstatat(AT_FDCWD, "/dev/loop0", {st_mode=S_IFBLK|0660, st_rdev=makedev(0x7, 0), ...}, 0) = 0
newfstatat(3, "", {st_mode=S_IFREG|0444, st_size=0, ...}, AT_EMPTY_PATH) = 0
read(3, "sysfs /sys sysfs rw,nosuid,nodev"..., 1024) = 1024
newfstatat(AT_FDCWD, "sysfs", 0x7ffdc498aab0, 0) = -1 ENOENT (No such file or directory)
newfstatat(AT_FDCWD, "proc", 0x7ffdc498aab0, 0) = -1 ENOENT (No such file or directory)
newfstatat(AT_FDCWD, "udev", 0x7ffdc498aab0, 0) = -1 ENOENT (No such file or directory)
newfstatat(AT_FDCWD, "devpts", 0x7ffdc498aab0, 0) = -1 ENOENT (No such file or directory)
newfstatat(AT_FDCWD, "tmpfs", 0x7ffdc498aab0, 0) = -1 ENOENT (No such file or directory)
newfstatat(AT_FDCWD, "/dev/vda1", {st_mode=S_IFBLK|0660, st_rdev=makedev(0xfe, 0x1), ...}, 0) = 0
newfstatat(AT_FDCWD, "securityfs", 0x7ffdc498aab0, 0) = -1 ENOENT (No such file or directory)
newfstatat(AT_FDCWD, "tmpfs", 0x7ffdc498aab0, 0) = -1 ENOENT (No such file or directory)
newfstatat(AT_FDCWD, "tmpfs", 0x7ffdc498aab0, 0) = -1 ENOENT (No such file or directory)
newfstatat(AT_FDCWD, "cgroup2", 0x7ffdc498aab0, 0) = -1 ENOENT (No such file or directory)
newfstatat(AT_FDCWD, "pstore", 0x7ffdc498aab0, 0) = -1 ENOENT (No such file or directory)
newfstatat(AT_FDCWD, "bpf", 0x7ffdc498aab0, 0) = -1 ENOENT (No such file or directory)
newfstatat(AT_FDCWD, "systemd-1", 0x7ffdc498aab0, 0) = -1 ENOENT (No such file or directory)
newfstatat(AT_FDCWD, "hugetlbfs", 0x7ffdc498aab0, 0) = -1 ENOENT (No such file or directory)
read(3, "queue /dev/mqueue mqueue rw,nosu"..., 1024) = 616
newfstatat(AT_FDCWD, "mqueue", 0x7ffdc498aab0, 0) = -1 ENOENT (No such file or directory)
newfstatat(AT_FDCWD, "tracefs", 0x7ffdc498aab0, 0) = -1 ENOENT (No such file or directory)
newfstatat(AT_FDCWD, "debugfs", 0x7ffdc498aab0, 0) = -1 ENOENT (No such file or directory)
newfstatat(AT_FDCWD, "fusectl", 0x7ffdc498aab0, 0) = -1 ENOENT (No such file or directory)
newfstatat(AT_FDCWD, "configfs", 0x7ffdc498aab0, 0) = -1 ENOENT (No such file or directory)
newfstatat(AT_FDCWD, "binfmt_misc", 0x7ffdc498aab0, 0) = -1 ENOENT (No such file or directory)
newfstatat(AT_FDCWD, "autopkgtest", 0x7ffdc498aab0, 0) = -1 ENOENT (No such file or directory)
newfstatat(AT_FDCWD, "tmpfs", 0x7ffdc498aab0, 0) = -1 ENOENT (No such file or directory)
read(3, "", 1024)                       = 0
newfstatat(AT_FDCWD, "/", {st_mode=S_IFDIR|0755, st_size=4096, ...}, 0) = 0
close(3)                                = 0
openat(AT_FDCWD, "/etc/mtab", O_RDONLY|O_CLOEXEC) = 3
newfstatat(AT_FDCWD, "/dev/loop0", {st_mode=S_IFBLK|0660, st_rdev=makedev(0x7, 0), ...}, 0) = 0
newfstatat(3, "", {st_mode=S_IFREG|0444, st_size=0, ...}, AT_EMPTY_PATH) = 0
read(3, "sysfs /sys sysfs rw,nosuid,nodev"..., 1024) = 1024
newfstatat(AT_FDCWD, "sysfs", 0x7ffdc498aab0, 0) = -1 ENOENT (No such file or directory)
newfstatat(AT_FDCWD, "proc", 0x7ffdc498aab0, 0) = -1 ENOENT (No such file or directory)
newfstatat(AT_FDCWD, "udev", 0x7ffdc498aab0, 0) = -1 ENOENT (No such file or directory)
newfstatat(AT_FDCWD, "devpts", 0x7ffdc498aab0, 0) = -1 ENOENT (No such file or directory)
newfstatat(AT_FDCWD, "tmpfs", 0x7ffdc498aab0, 0) = -1 ENOENT (No such file or directory)
newfstatat(AT_FDCWD, "/dev/vda1", {st_mode=S_IFBLK|0660, st_rdev=makedev(0xfe, 0x1), ...}, 0) = 0
newfstatat(AT_FDCWD, "securityfs", 0x7ffdc498aab0, 0) = -1 ENOENT (No such file or directory)
newfstatat(AT_FDCWD, "tmpfs", 0x7ffdc498aab0, 0) = -1 ENOENT (No such file or directory)
newfstatat(AT_FDCWD, "tmpfs", 0x7ffdc498aab0, 0) = -1 ENOENT (No such file or directory)
newfstatat(AT_FDCWD, "cgroup2", 0x7ffdc498aab0, 0) = -1 ENOENT (No such file or directory)
newfstatat(AT_FDCWD, "pstore", 0x7ffdc498aab0, 0) = -1 ENOENT (No such file or directory)
newfstatat(AT_FDCWD, "bpf", 0x7ffdc498aab0, 0) = -1 ENOENT (No such file or directory)
newfstatat(AT_FDCWD, "systemd-1", 0x7ffdc498aab0, 0) = -1 ENOENT (No such file or directory)
newfstatat(AT_FDCWD, "hugetlbfs", 0x7ffdc498aab0, 0) = -1 ENOENT (No such file or directory)
read(3, "queue /dev/mqueue mqueue rw,nosu"..., 1024) = 616
newfstatat(AT_FDCWD, "mqueue", 0x7ffdc498aab0, 0) = -1 ENOENT (No such file or directory)
newfstatat(AT_FDCWD, "tracefs", 0x7ffdc498aab0, 0) = -1 ENOENT (No such file or directory)
newfstatat(AT_FDCWD, "debugfs", 0x7ffdc498aab0, 0) = -1 ENOENT (No such file or directory)
newfstatat(AT_FDCWD, "fusectl", 0x7ffdc498aab0, 0) = -1 ENOENT (No such file or directory)
newfstatat(AT_FDCWD, "configfs", 0x7ffdc498aab0, 0) = -1 ENOENT (No such file or directory)
newfstatat(AT_FDCWD, "binfmt_misc", 0x7ffdc498aab0, 0) = -1 ENOENT (No such file or directory)
newfstatat(AT_FDCWD, "autopkgtest", 0x7ffdc498aab0, 0) = -1 ENOENT (No such file or directory)
newfstatat(AT_FDCWD, "tmpfs", 0x7ffdc498aab0, 0) = -1 ENOENT (No such file or directory)
read(3, "", 1024)                       = 0
newfstatat(AT_FDCWD, "/", {st_mode=S_IFDIR|0755, st_size=4096, ...}, 0) = 0
close(3)                                = 0
newfstatat(AT_FDCWD, "/dev/loop0", {st_mode=S_IFBLK|0660, st_rdev=makedev(0x7, 0), ...}, 0) = 0
openat(AT_FDCWD, "/dev/loop0", O_RDONLY|O_EXCL) = 3
close(3)                                = 0
rt_sigaction(SIGTERM, {sa_handler=0x563052e98e30, sa_mask=[TERM], sa_flags=SA_RESTORER|SA_RESTART, sa_restorer=0x7f61b3240510}, {sa_handler=SIG_DFL, sa_mask=[], sa_flags=0}, 8) = 0
rt_sigaction(SIGINT, {sa_handler=0x563052e98e30, sa_mask=[INT], sa_flags=SA_RESTORER|SA_RESTART, sa_restorer=0x7f61b3240510}, {sa_handler=SIG_IGN, sa_mask=[], sa_flags=0}, 8) = 0
openat(AT_FDCWD, "/dev/loop0", O_RDWR|O_DIRECT) = 3
pread64(3, "\2\2\2\2\2\2\2\2this is an ocfs2 volume\0"..., 512, 0) = 512
uname({sysname="Linux", nodename="debian", ...}) = 0
ioctl(3, BLKROGET, [0])                 = 0
pread64(3, "\2\2\2\2\2\2\2\2this is an ocfs2 volume\0"..., 512, 0) = 512
pread64(3, "\2\2\2\2\2\2\2\2\2\2\2\2\2\2\2\2\2\2\2\2\2\2\2\2\2\2\2\2\2\2\2\2"..., 512, 1024) = 512
pread64(3, "OCFSV2\0\0L\23\t<\377\377\377\377\0\0\0\0\0\310\0\0\0\0\0\0\0\0\0\0"..., 1024, 2048) = 1024
openat(AT_FDCWD, "/sys/fs/ocfs2/cluster_stack", O_RDONLY) = 4
newfstatat(4, "", {st_mode=S_IFREG|0644, st_size=4096, ...}, AT_EMPTY_PATH) = 0
read(4, "pcmk\n", 4096)                 = 5
close(4)                                = 0
openat(AT_FDCWD, "/sys/fs/o2cb/interface_revision", O_RDONLY) = 4
read(4, "5\n", 15)                      = 2
read(4, "", 13)                         = 0
close(4)                                = 0
newfstatat(AT_FDCWD, "/sys/kernel/config", {st_mode=S_IFDIR|0755, st_size=0, ...}, 0) = 0
statfs("/sys/kernel/config", {f_type=CONFIGFS_MAGIC, f_bsize=4096, f_blocks=0, f_bfree=0, f_bavail=0, f_files=0, f_ffree=0, f_fsid={val=[0x20, 0]}, f_namelen=255, f_frsize=4096, f_flags=ST_VALID|ST_NOSUID|ST_NODEV|ST_NOEXEC|ST_RELATIME}) = 0
rt_sigprocmask(SIG_BLOCK, ~[TRAP SEGV RTMIN RT_1], NULL, 8) = 0
openat(AT_FDCWD, "/dev/loop0", O_RDONLY) = 4
ioctl(4, BLKSSZGET, [512])              = 0
close(4)                                = 0
pread64(3, "INODE01\0L\23\t<\377\377\2\0\0\0\0\0\1\0\0\0\0\0\0\0\0\0\0\0"..., 1024, 10240) = 1024
pread64(3, "INODE01\0L\23\t<\377\377\2\0\0\0\0\0\1\0\0\0\0\0\0\0\0\0\0\0"..., 1024, 10240) = 1024
pread64(3, "INODE01\0L\23\t<\377\377\2\0\0\0\0\0\1\0\0\0\0\0\0\0\0\0\0\0"..., 1024, 10240) = 1024
pread64(3, "INODE01\0L\23\t<\377\377\2\0\0\0\0\0\1\0\0\0\0\0\0\0\0\0\0\0"..., 1024, 10240) = 1024
pread64(3, "\n\0\0\0\0\0\0\0\20\0\1\2.\0\0\0\n\0\0\0\0\0\0\0\20\0\2\2..\0\0"..., 1024, 286720) = 1024
pread64(3, "INODE01\0L\23\t<\377\377\6\0\0\0\0\0@\0\0\0\0\0\0\0\0\0\0\0"..., 1024, 14336) = 1024
openat(AT_FDCWD, "/sys/module/ocfs2_dlmfs/parameters/capabilities", O_RDONLY) = -1 ENOENT (No such file or directory)
openat(AT_FDCWD, "/proc/misc", O_RDONLY) = 4
newfstatat(4, "", {st_mode=S_IFREG|0444, st_size=0, ...}, AT_EMPTY_PATH) = 0
read(4, "122 dlm_plock\n123 dlm-monitor\n12"..., 1024) = 220
close(4)                                = 0
newfstatat(AT_FDCWD, "/dev/misc/dlm-control", {st_mode=S_IFCHR|0666, st_rdev=makedev(0xa, 0x7c), ...}, 0) = 0
openat(AT_FDCWD, "/dev/misc/dlm-control", O_RDWR) = 4
fcntl(4, F_SETFD, FD_CLOEXEC)           = 0
read(4, "\6\0\0\0\0\0\0\0\2\0\0\0", 12) = 12
openat(AT_FDCWD, "/sys/fs/ocfs2/dlm_recover_callback_support", O_RDONLY) = 5
newfstatat(5, "", {st_mode=S_IFREG|0444, st_size=4096, ...}, AT_EMPTY_PATH) = 0
read(5, "1\n", 4096)                    = 2
close(5)                                = 0
openat(AT_FDCWD, "/dev/urandom", O_RDONLY) = 5
read(5, "\221cK\240s\342\265\212", 8)   = 8
close(5)                                = 0
brk(0x563054cc9000)                     = 0x563054cc9000
fcntl(4, F_SETFD, FD_CLOEXEC)           = 0
write(4, "\6\0\0\0\0\0\0\0\2\0\0\0\4\1\0\0\0\0\0\0\0\0\0\00048E8C81F"..., 152) = 121
newfstatat(AT_FDCWD, "/dev/misc/dlm_48E8C81F039C4F5E9CC099C954C14D46", 0x7ffdc4986d90, 0) = -1 ENOENT (No such file or directory)
openat(AT_FDCWD, "/dev/misc/", O_RDONLY|O_NONBLOCK|O_CLOEXEC|O_DIRECTORY) = 5
newfstatat(5, "", {st_mode=S_IFDIR|0755, st_size=120, ...}, AT_EMPTY_PATH) = 0
getdents64(5, 0x563054ca9790 /* 6 entries */, 32768) = 200
newfstatat(AT_FDCWD, "/dev/misc/dlm_48E8C81F039C4F5E9CC099C954C14D46", {st_mode=S_IFCHR|0660, st_rdev=makedev(0xa, 0x79), ...}, 0) = 0
close(5)                                = 0
openat(AT_FDCWD, "/dev/misc/dlm_48E8C81F039C4F5E9CC099C954C14D46", O_RDWR) = 5
fchmod(5, 0600)                         = 0
fcntl(5, F_SETFD, FD_CLOEXEC)           = 0
write(5, "\6\0\0\0\0\0\0\0\2\0\0\0\1\1\0\0\3\21\0\0\10\0\0\0\0\0\0\0\0\0\0\0"..., 137) = 1
read(5, "\6\0\0\0\0\0\0\0\2\0\0\0h\0\0\0\20\243?\263a\177\0\0\0\0\0\0\0\0\0\0"..., 104) = 104
openat(AT_FDCWD, "/sys/fs/ocfs2/dlm_recover_callback_support", O_RDONLY) = 6
newfstatat(6, "", {st_mode=S_IFREG|0444, st_size=4096, ...}, AT_EMPTY_PATH) = 0
read(6, "1\n", 4096)                    = 2
close(6)                                = 0
pread64(3, "INODE01\0L\23\t<\377\377\2\0\0\0\0\0\1\0\0\0\0\0\0\0\0\0\0\0"..., 1024, 10240) = 1024
pread64(3, "INODE01\0L\23\t<\377\377\2\0\0\0\0\0\1\0\0\0\0\0\0\0\0\0\0\0"..., 1024, 10240) = 1024
pread64(3, "INODE01\0L\23\t<\377\377\2\0\0\0\0\0\1\0\0\0\0\0\0\0\0\0\0\0"..., 1024, 10240) = 1024
pread64(3, "INODE01\0L\23\t<\377\377\2\0\0\0\0\0\1\0\0\0\0\0\0\0\0\0\0\0"..., 1024, 10240) = 1024
pread64(3, "\n\0\0\0\0\0\0\0\20\0\1\2.\0\0\0\n\0\0\0\0\0\0\0\20\0\2\2..\0\0"..., 1024, 286720) = 1024
pread64(3, "INODE01\0L\23\t<\377\377\2\0\0\0\0\0\1\0\0\0\0\0\0\0\0\0\0\0"..., 1024, 10240) = 1024
pread64(3, "INODE01\0L\23\t<\377\377\2\0\0\0\0\0\1\0\0\0\0\0\0\0\0\0\0\0"..., 1024, 10240) = 1024
pread64(3, "INODE01\0L\23\t<\377\377\2\0\0\0\0\0\1\0\0\0\0\0\0\0\0\0\0\0"..., 1024, 10240) = 1024
pread64(3, "INODE01\0L\23\t<\377\377\2\0\0\0\0\0\1\0\0\0\0\0\0\0\0\0\0\0"..., 1024, 10240) = 1024
pread64(3, "\n\0\0\0\0\0\0\0\20\0\1\2.\0\0\0\n\0\0\0\0\0\0\0\20\0\2\2..\0\0"..., 1024, 286720) = 1024
write(5, "\6\0\0\0\0\0\0\0\2\0\0\0\1\1\0\0\5\37\0\0\t\0\0\0\0\0\0\0\0\0\0\0"..., 151) = 2
read(5, "\6\0\0\0\0\0\0\0\2\0\0\0H\0\0\0\20\243?\263a\177\0\0\0\0\0\0\0\0\0\0"..., 104) = 72
pread64(3, "INODE01\0L\23\t<\377\377\20\0\0\0\0\0\0\4\0\0\0\0\0\0\0\0\0\0"..., 1024, 24576) = 1024
write(5, "\6\0\0\0\0\0\0\0\2\0\0\0\1\1\0\0\5\37\0\0\t\0\0\0\0\0\0\0\0\0\0\0"..., 151) = 3
read(5, "\6\0\0\0\0\0\0\0\2\0\0\0H\0\0\0\20\243?\263a\177\0\0\0\0\0\0\0\0\0\0"..., 104) = 72
write(5, "\6\0\0\0\0\0\0\0\2\0\0\0\2\1\0\0\0\0\0\0\10\0\0\0\3\0\0\0\0\0\0\0"..., 120) = 0
read(5, "\6\0\0\0\0\0\0\0\2\0\0\0H\0\0\0\20\243?\263a\177\0\0\0\0\0\0\0\0\0\0"..., 104) = 72
pread64(3, "INODE01\0L\23\t<\377\377\21\0\0\0\0\0\0\4\0\0\0\0\0\0\0\0\0\0"..., 1024, 25600) = 1024
write(5, "\6\0\0\0\0\0\0\0\2\0\0\0\1\1\0\0\5\37\0\0\t\0\0\0\0\0\0\0\0\0\0\0"..., 151) = 4
read(5, "\6\0\0\0\0\0\0\0\2\0\0\0H\0\0\0\20\243?\263a\177\0\0\0\0\0\0\0\0\0\0"..., 104) = 72
write(5, "\6\0\0\0\0\0\0\0\2\0\0\0\2\1\0\0\0\0\0\0\10\0\0\0\4\0\0\0\0\0\0\0"..., 120) = 0
read(5, "\6\0\0\0\0\0\0\0\2\0\0\0H\0\0\0\20\243?\263a\177\0\0\0\0\0\0\0\0\0\0"..., 104) = 72
rt_sigprocmask(SIG_UNBLOCK, ~[TRAP SEGV RTMIN RT_1], NULL, 8) = 0
newfstatat(1, "", {st_mode=S_IFIFO|0644, st_size=0, ...}, AT_EMPTY_PATH) = 0
write(1, "Checking OCFS2 filesystem in /de"..., 41) = 41
write(1, "  Label:              <NONE>\n", 29) = 29
write(1, "  UUID:               48E8C81F03"..., 55) = 55
write(1, "  Number of blocks:   204800\n", 29) = 29
write(1, "  Block size:         1024\n", 27) = 27
write(1, "  Number of clusters: 51200\n", 28) = 28
write(1, "  Cluster size:       4096\n", 27) = 27
write(1, "  Number of slots:    2\n\n", 25) = 25
sysinfo({uptime=52, loads=[29440, 8064, 2688], totalram=1024217088, freeram=251826176, sharedram=21729280, bufferram=13910016, totalswap=0, freeswap=0, procs=113, totalhigh=0, freehigh=0, mem_unit=1}) = 0
mmap(NULL, 50368512, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f61afe00000
munmap(0x7f61afe00000, 50368512)        = 0
mmap(NULL, 50368512, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f61afe00000
mmap(NULL, 3149824, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f61afa00000
sysinfo({uptime=52, loads=[29440, 8064, 2688], totalram=1024217088, freeram=251826176, sharedram=21729280, bufferram=13910016, totalswap=0, freeswap=0, procs=113, totalhigh=0, freehigh=0, mem_unit=1}) = 0
mlock(0x7f61afe00400, 50364416)         = 0
mlock(0x7f61afa00010, 3147776)          = 0
pread64(3, "INODE01\0L\23\t<\377\377\2\0\0\0\0\0\1\0\0\0\0\0\0\0\0\0\0\0"..., 1024, 10240) = 1024
pread64(3, "\n\0\0\0\0\0\0\0\20\0\1\2.\0\0\0\n\0\0\0\0\0\0\0\20\0\2\2..\0\0"..., 1024, 286720) = 1024
pread64(3, "INODE01\0L\23\t<\377\377\20\0\0\0\0\0\0\4\0\0\0\0\0\0\0\0\0\0"..., 1024, 24576) = 1024
pread64(3, "\300;9\230\0\0\0\4\0\0\0\0\0\0\4\0\0\0\20\0\0\0\0\1\0\0\0\1\0\0\0\1"..., 1024, 552960) = 1024
pread64(3, "INODE01\0L\23\t<\377\377\21\0\0\0\0\0\0\4\0\0\0\0\0\0\0\0\0\0"..., 1024, 25600) = 1024
pread64(3, "\300;9\230\0\0\0\4\0\0\0\0\0\0\4\0\0\0\20\0\0\0\0\1\0\0\0\1\0\0\0\1"..., 1024, 4747264) = 1024
brk(0x563054cea000)                     = 0x563054cea000
sysinfo({uptime=52, loads=[29440, 8064, 2688], totalram=1024217088, freeram=201494528, sharedram=21729280, bufferram=13910016, totalswap=0, freeswap=0, procs=113, totalhigh=0, freehigh=0, mem_unit=1}) = 0
munlock(0x7f61afe00400, 50364416)       = 0
munmap(0x7f61afe00000, 50368512)        = 0
munlock(0x7f61afa00010, 3147776)        = 0
munmap(0x7f61afa00000, 3149824)         = 0
mmap(NULL, 40300544, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f61b0600000
munmap(0x7f61b0600000, 40300544)        = 0
mmap(NULL, 40300544, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f61b0600000
brk(0x563054f61000)                     = 0x563054f61000
sysinfo({uptime=52, loads=[29440, 8064, 2688], totalram=1024217088, freeram=220368896, sharedram=21729280, bufferram=13910016, totalswap=0, freeswap=0, procs=113, totalhigh=0, freehigh=0, mem_unit=1}) = 0
mlock(0x7f61b0600400, 40296448)         = 0
mlock(0x563054cd9650, 2518528)          = 0
munlock(0x7f61b0600400, 40296448)       = 0
munmap(0x7f61b0600000, 40300544)        = 0
munlock(0x563054cd9650, 2518528)        = 0
mmap(NULL, 20152320, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f61b1a00000
munmap(0x7f61b1a00000, 20152320)        = 0
brk(0x563056031000)                     = 0x563056031000
brk(0x563056165000)                     = 0x563056165000
sysinfo({uptime=52, loads=[29440, 8064, 2688], totalram=1024217088, freeram=216174592, sharedram=21729280, bufferram=13910016, totalswap=0, freeswap=0, procs=113, totalhigh=0, freehigh=0, mem_unit=1}) = 0
mlock(0x563054cd9800, 20148224)         = 0
mlock(0x563056010a90, 1259264)          = 0
pread64(3, "INODE01\0L\23\t<\377\377\2\0\0\0\0\0\1\0\0\0\0\0\0\0\0\0\0\0"..., 1024, 10240) = 1024
pread64(3, "\n\0\0\0\0\0\0\0\20\0\1\2.\0\0\0\n\0\0\0\0\0\0\0\20\0\2\2..\0\0"..., 1024, 286720) = 1024
pread64(3, "INODE01\0L\23\t<\377\377\22\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 1024, 26624) = 1024
pread64(3, "INODE01\0L\23\t<\377\377\23\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 1024, 27648) = 1024
pread64(3, "INODE01\0L\23\t<\377\377\24\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 1024, 28672) = 1024
pwrite64(3, "INODE01\0L\23\t<\377\377\24\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 1024, 28672) = 1024
pread64(3, "INODE01\0L\23\t<\377\377\25\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 1024, 29696) = 1024
pwrite64(3, "INODE01\0L\23\t<\377\377\25\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 1024, 29696) = 1024
write(1, "/dev/loop0 was run with -f, chec"..., 42) = 42
write(1, "Pass 0a: Checking cluster alloca"..., 44) = 44
getrusage(RUSAGE_SELF, {ru_utime={tv_sec=0, tv_usec=33247}, ru_stime={tv_sec=0, tv_usec=546077}, ...}) = 0
pread64(3, "INODE01\0L\23\t<\377\377\7\0\0\0\0\0\0\310\0\0\0\0\0\0\0\0\0\0"..., 1024, 15360) = 1024
io_setup(7, [0x7f61b3404000])           = 0
io_submit(0x7f61b3404000, 7, [{aio_data=0, aio_lio_opcode=IOCB_CMD_PREAD, aio_fildes=3, aio_buf=0x56305615a800, aio_nbytes=1024, aio_offset=4096}, {aio_data=0, aio_lio_opcode=IOCB_CMD_PREAD, aio_fildes=3, aio_buf=0x56305615ac00, aio_nbytes=1024, aio_offset=31457280}, {aio_data=0, aio_lio_opcode=IOCB_CMD_PREAD, aio_fildes=3, aio_buf=0x56305615b000, aio_nbytes=1024, aio_offset=62914560}, {aio_data=0, aio_lio_opcode=IOCB_CMD_PREAD, aio_fildes=3, aio_buf=0x56305615b400, aio_nbytes=1024, aio_offset=94371840}, {aio_data=0, aio_lio_opcode=IOCB_CMD_PREAD, aio_fildes=3, aio_buf=0x56305615b800, aio_nbytes=1024, aio_offset=125829120}, {aio_data=0, aio_lio_opcode=IOCB_CMD_PREAD, aio_fildes=3, aio_buf=0x56305615bc00, aio_nbytes=1024, aio_offset=157286400}, {aio_data=0, aio_lio_opcode=IOCB_CMD_PREAD, aio_fildes=3, aio_buf=0x56305615c000, aio_nbytes=1024, aio_offset=188743680}]) = 7
io_pgetevents(0x7f61b3404000, 7, 7, [{data=0, obj=0x5630561553b0, res=1024, res2=0}, {data=0, obj=0x563056155370, res=1024, res2=0}, {data=0, obj=0x563056155330, res=1024, res2=0}, {data=0, obj=0x5630561552f0, res=1024, res2=0}, {data=0, obj=0x5630561552b0, res=1024, res2=0}, {data=0, obj=0x563056155270, res=1024, res2=0}, {data=0, obj=0x563056155230, res=1024, res2=0}], NULL, {sigmask=NULL, sigsetsize=8}) = 7
io_destroy(0x7f61b3404000)              = 0
getrusage(RUSAGE_SELF, {ru_utime={tv_sec=0, tv_usec=33261}, ru_stime={tv_sec=0, tv_usec=546303}, ...}) = 0
write(1, "Pass 0b: Checking inode allocati"..., 42) = 42
getrusage(RUSAGE_SELF, {ru_utime={tv_sec=0, tv_usec=33263}, ru_stime={tv_sec=0, tv_usec=546336}, ...}) = 0
pread64(3, "INODE01\0L\23\t<\377\377\4\0\0\0\0\0D\0\0\0\0\0\0\0\0\0\0\0"..., 1024, 12288) = 1024
io_setup(1, [0x7f61b3404000])           = 0
io_submit(0x7f61b3404000, 1, [{aio_data=0, aio_lio_opcode=IOCB_CMD_PREAD, aio_fildes=3, aio_buf=0x563056148800, aio_nbytes=1024, aio_offset=8192}]) = 1
io_pgetevents(0x7f61b3404000, 1, 1, [{data=0, obj=0x563056158bb0, res=1024, res2=0}], NULL, {sigmask=NULL, sigsetsize=8}) = 1
io_destroy(0x7f61b3404000)              = 0
pread64(3, "INODE01\0L\23\t<\377\377\16\0\0\0\0\0\0\2\0\0\0\0\0\0\0\0\0\0"..., 1024, 22528) = 1024
io_setup(1, [0x7f61b3404000])           = 0
io_submit(0x7f61b3404000, 1, [{aio_data=0, aio_lio_opcode=IOCB_CMD_PREAD, aio_fildes=3, aio_buf=0x563056148800, aio_nbytes=1024, aio_offset=13172736}]) = 1
io_pgetevents(0x7f61b3404000, 1, 1, [{data=0, obj=0x563056158bb0, res=1024, res2=0}], NULL, {sigmask=NULL, sigsetsize=8}) = 1
io_destroy(0x7f61b3404000)              = 0
brk(0x563056186000)                     = 0x563056186000
pread64(3, "INODE01\0L\23\t<\377\377\17\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 1024, 23552) = 1024
getrusage(RUSAGE_SELF, {ru_utime={tv_sec=0, tv_usec=33331}, ru_stime={tv_sec=0, tv_usec=547451}, ...}) = 0
write(1, "Pass 0c: Checking extent block a"..., 49) = 49
getrusage(RUSAGE_SELF, {ru_utime={tv_sec=0, tv_usec=33335}, ru_stime={tv_sec=0, tv_usec=547517}, ...}) = 0
pread64(3, "INODE01\0L\23\t<\377\377\f\0\0\0\0\0\0\2\0\0\0\0\0\0\0\0\0\0"..., 1024, 20480) = 1024
io_setup(1, [0x7f61b3404000])           = 0
io_submit(0x7f61b3404000, 1, [{aio_data=0, aio_lio_opcode=IOCB_CMD_PREAD, aio_fildes=3, aio_buf=0x56305616b800, aio_nbytes=1024, aio_offset=8941568}]) = 1
io_pgetevents(0x7f61b3404000, 1, 1, [{data=0, obj=0x56305616abb0, res=1024, res2=0}], NULL, {sigmask=NULL, sigsetsize=8}) = 1
io_destroy(0x7f61b3404000)              = 0
pread64(3, "INODE01\0L\23\t<\377\377\r\0\0\0\0\0\0\2\0\0\0\0\0\0\0\0\0\0"..., 1024, 21504) = 1024
io_setup(1, [0x7f61b3404000])           = 0
io_submit(0x7f61b3404000, 1, [{aio_data=0, aio_lio_opcode=IOCB_CMD_PREAD, aio_fildes=3, aio_buf=0x56305616b800, aio_nbytes=1024, aio_offset=11038720}]) = 1
io_pgetevents(0x7f61b3404000, 1, 1, [{data=0, obj=0x563056172fb0, res=1024, res2=0}], NULL, {sigmask=NULL, sigsetsize=8}) = 1
io_destroy(0x7f61b3404000)              = 0
getrusage(RUSAGE_SELF, {ru_utime={tv_sec=0, tv_usec=33390}, ru_stime={tv_sec=0, tv_usec=548424}, ...}) = 0
write(1, "Pass 1: Checking inodes and bloc"..., 35) = 35
getrusage(RUSAGE_SELF, {ru_utime={tv_sec=0, tv_usec=33394}, ru_stime={tv_sec=0, tv_usec=548492}, ...}) = 0
brk(0x563056597000)                     = 0x563056597000
pread64(3, "INODE01\0L\23\t<\377\377\1\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 277504, 9216) = 277504
pread64(3, "INODE01\0L\23\t<\0\0\1\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 1048576, 13173760) = 1048576
pread64(3, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 1047552, 14222336) = 1047552
getrusage(RUSAGE_SELF, {ru_utime={tv_sec=0, tv_usec=38873}, ru_stime={tv_sec=0, tv_usec=548492}, ...}) = 0
write(1, "Pass 2: Checking directory entri"..., 35) = 35
getrusage(RUSAGE_SELF, {ru_utime={tv_sec=0, tv_usec=38975}, ru_stime={tv_sec=0, tv_usec=548492}, ...}) = 0
io_setup(8, [0x7f61b3404000])           = 0
io_submit(0x7f61b3404000, 8, [{aio_data=0, aio_lio_opcode=IOCB_CMD_PREAD, aio_fildes=3, aio_buf=0x563056176400, aio_nbytes=1024, aio_offset=9216}, {aio_data=0, aio_lio_opcode=IOCB_CMD_PREAD, aio_fildes=3, aio_buf=0x563056176800, aio_nbytes=1024, aio_offset=18432}, {aio_data=0, aio_lio_opcode=IOCB_CMD_PREAD, aio_fildes=3, aio_buf=0x563056176c00, aio_nbytes=1024, aio_offset=19456}, {aio_data=0, aio_lio_opcode=IOCB_CMD_PREAD, aio_fildes=3, aio_buf=0x563056177000, aio_nbytes=1024, aio_offset=286720}, {aio_data=0, aio_lio_opcode=IOCB_CMD_PREAD, aio_fildes=3, aio_buf=0x563056177400, aio_nbytes=1024, aio_offset=287744}, {aio_data=0, aio_lio_opcode=IOCB_CMD_PREAD, aio_fildes=3, aio_buf=0x563056177800, aio_nbytes=1024, aio_offset=288768}, {aio_data=0, aio_lio_opcode=IOCB_CMD_PREAD, aio_fildes=3, aio_buf=0x563056177c00, aio_nbytes=1024, aio_offset=289792}, {aio_data=0, aio_lio_opcode=IOCB_CMD_PREAD, aio_fildes=3, aio_buf=0x563056178000, aio_nbytes=1024, aio_offset=13173760}]) = 8
io_pgetevents(0x7f61b3404000, 8, 8, [{data=0, obj=0x563056154bb0, res=1024, res2=0}, {data=0, obj=0x563056154b70, res=1024, res2=0}, {data=0, obj=0x563056154b30, res=1024, res2=0}, {data=0, obj=0x563056154af0, res=1024, res2=0}, {data=0, obj=0x563056154ab0, res=1024, res2=0}, {data=0, obj=0x563056154a70, res=1024, res2=0}, {data=0, obj=0x563056154a30, res=1024, res2=0}, {data=0, obj=0x5630561549f0, res=1024, res2=0}], NULL, {sigmask=NULL, sigsetsize=8}) = 8
io_destroy(0x7f61b3404000)              = 0
io_setup(1, [0x7f61b3404000])           = 0
io_submit(0x7f61b3404000, 1, [{aio_data=0, aio_lio_opcode=IOCB_CMD_PREAD, aio_fildes=3, aio_buf=0x563056163400, aio_nbytes=1024, aio_offset=8192}]) = 1
io_pgetevents(0x7f61b3404000, 1, 1, [{data=0, obj=0x563056172fb0, res=1024, res2=0}], NULL, {sigmask=NULL, sigsetsize=8}) = 1
io_destroy(0x7f61b3404000)              = 0
io_setup(1, [0x7f61b3404000])           = 0
io_submit(0x7f61b3404000, 1, [{aio_data=0, aio_lio_opcode=IOCB_CMD_PREAD, aio_fildes=3, aio_buf=0x563056157400, aio_nbytes=1024, aio_offset=13172736}]) = 1
io_pgetevents(0x7f61b3404000, 1, 1, [{data=0, obj=0x563056172fb0, res=1024, res2=0}], NULL, {sigmask=NULL, sigsetsize=8}) = 1
io_destroy(0x7f61b3404000)              = 0
write(1, "[DX_TREE_MISSING] Directory 10 i"..., 57) = 57
write(1, " y\n", 3)                     = 3
pwrite64(3, "\n\0\0\0\0\0\0\0\20\0\1\2.\0\0\0\n\0\0\0\0\0\0\0\20\0\2\2..\0\0"..., 1024, 286720) = 1024
pread64(3, "p$\365\f\0\0\0\0\200:\t\0\200:\t\0\20'\0\0\7\0\0\0\0\0\0\0\6\0\0\0"..., 1024, 13139968) = 1024
pread64(3, "q$\365\f\0\0\0\0\200:\t\0\200:\t\0\20'\0\0\7\0\0\0\0\0\0\0\6\0\0\0"..., 1024, 13152256) = 1024
io_setup(1, [0x7f61b3404000])           = 0
io_submit(0x7f61b3404000, 1, [{aio_data=0, aio_lio_opcode=IOCB_CMD_PREAD, aio_fildes=3, aio_buf=0x56305657f800, aio_nbytes=1024, aio_offset=8941568}]) = 1
io_pgetevents(0x7f61b3404000, 1, 1, [{data=0, obj=0x563056158bb0, res=1024, res2=0}], NULL, {sigmask=NULL, sigsetsize=8}) = 1
io_destroy(0x7f61b3404000)              = 0
pwrite64(3, "GROUP01\0\0\1\0\10\376\7\0\0L\23\t<\0\0\0\0\0\0\0\0\0\0\0\0"..., 1024, 8941568) = 1024
pwrite64(3, "INODE01\0L\23\t<\377\377\f\0\0\0\0\0\0\2\0\0\0\0\0\0\0\0\0\0"..., 1024, 20480) = 1024
pwrite64(3, "DXDIR01\0\211\270\365\260\265\3\0\0\0\0\1\0L\23\t<\35\"\0\0\0\0\0\0"..., 1024, 8942592) = 1024
pwrite64(3, "\n\0\0\0\0\0\0\0\20\0\1\2.\0\0\0\n\0\0\0\0\0\0\0\20\0\2\2..\0\0"..., 1024, 286720) = 1024
pwrite64(3, "DXDIR01\0\237\27d\200\241\1\0\0\0\0\1\0L\23\t<\35\"\0\0\0\0\0\0"..., 1024, 8942592) = 1024
pwrite64(3, "INODE01\0L\23\t<\377\377\2\0\0\0\0\0\1\0\0\0\0\0\0\0\0\0\0\0"..., 1024, 10240) = 1024
pwrite64(3, "DXDIR01\0\262@\254\245\334\0\0\0\0\0\1\0L\23\t<\35\"\0\0\0\0\0\0"..., 1024, 8942592) = 1024
pwrite64(3, "DXDIR01\0\177\233\217\370\327\7\0\0\0\0\1\0L\23\t<\35\"\0\0\0\0\0\0"..., 1024, 8942592) = 1024
pwrite64(3, "DXDIR01\0\377\204g\24\336\0\0\0\0\0\1\0L\23\t<\35\"\0\0\0\0\0\0"..., 1024, 8942592) = 1024
pwrite64(3, "DXDIR01\0u\236n\322\363\0\0\0\0\0\1\0L\23\t<\35\"\0\0\0\0\0\0"..., 1024, 8942592) = 1024
pwrite64(3, "DXDIR01\0\n4z\265\317\7\0\0\0\0\1\0L\23\t<\35\"\0\0\0\0\0\0"..., 1024, 8942592) = 1024
pwrite64(3, "DXDIR01\0\0b`\367\342\7\0\0\0\0\1\0L\23\t<\35\"\0\0\0\0\0\0"..., 1024, 8942592) = 1024
pwrite64(3, "DXDIR01\0\303\271\272\342\363\0\0\0\0\0\1\0L\23\t<\35\"\0\0\0\0\0\0"..., 1024, 8942592) = 1024
pwrite64(3, "DXDIR01\0\0172\365\275\t\t\0\0\0\0\1\0L\23\t<\35\"\0\0\0\0\0\0"..., 1024, 8942592) = 1024
pwrite64(3, "DXDIR01\0\233\214\21a\213\4\0\0\0\0\1\0L\23\t<\35\"\0\0\0\0\0\0"..., 1024, 8942592) = 1024
pwrite64(3, "DXDIR01\0\27\363,B\232\4\0\0\0\0\1\0L\23\t<\35\"\0\0\0\0\0\0"..., 1024, 8942592) = 1024
pwrite64(3, "DXDIR01\0\231\337}\24\31\10\0\0\0\0\1\0L\23\t<\35\"\0\0\0\0\0\0"..., 1024, 8942592) = 1024
pwrite64(3, "DXDIR01\0\200\264I|\6\4\0\0\0\0\1\0L\23\t<\35\"\0\0\0\0\0\0"..., 1024, 8942592) = 1024
pwrite64(3, "DXDIR01\0q\6\316\373U\17\0\0\0\0\1\0L\23\t<\35\"\0\0\0\0\0\0"..., 1024, 8942592) = 1024
pwrite64(3, "DXDIR01\0\261C\321\320k\2\0\0\0\0\1\0L\23\t<\35\"\0\0\0\0\0\0"..., 1024, 8942592) = 1024
pwrite64(3, "DXDIR01\0!\324',\362\10\0\0\0\0\1\0L\23\t<\35\"\0\0\0\0\0\0"..., 1024, 8942592) = 1024
pwrite64(3, "DXDIR01\0\343\20\n\340\232\f\0\0\0\0\1\0L\23\t<\35\"\0\0\0\0\0\0"..., 1024, 8942592) = 1024
pwrite64(3, "DXDIR01\0T\214\2611\3\5\0\0\0\0\1\0L\23\t<\35\"\0\0\0\0\0\0"..., 1024, 8942592) = 1024
pwrite64(3, "DXDIR01\0\336aa\3229\5\0\0\0\0\1\0L\23\t<\35\"\0\0\0\0\0\0"..., 1024, 8942592) = 1024
pwrite64(3, "DXDIR01\0k\274\244\3l\r\0\0\0\0\1\0L\23\t<\35\"\0\0\0\0\0\0"..., 1024, 8942592) = 1024
pwrite64(3, "DXDIR01\0s\322D\305\275\32\0\0\0\0\1\0L\23\t<\35\"\0\0\0\0\0\0"..., 1024, 8942592) = 1024
pwrite64(3, "DXDIR01\0\334\304\302\352s\35\0\0\0\0\1\0L\23\t<\35\"\0\0\0\0\0\0"..., 1024, 8942592) = 1024
pwrite64(3, "DXDIR01\0\200+]\37\254\r\0\0\0\0\1\0L\23\t<\35\"\0\0\0\0\0\0"..., 1024, 8942592) = 1024
pwrite64(3, "DXDIR01\0\241\320\204\4=\33\0\0\0\0\1\0L\23\t<\35\"\0\0\0\0\0\0"..., 1024, 8942592) = 1024
pwrite64(3, "DXDIR01\0\25\234Q\5\5\33\0\0\0\0\1\0L\23\t<\35\"\0\0\0\0\0\0"..., 1024, 8942592) = 1024
pwrite64(3, "DXDIR01\0i\252\342\7\31\34\0\0\0\0\1\0L\23\t<\35\"\0\0\0\0\0\0"..., 1024, 8942592) = 1024
pwrite64(3, "INODE01\0L\23\t<\377\377\2\0\0\0\0\0\1\0\0\0\0\0\0\0\0\0\0\0"..., 1024, 10240) = 1024
pread64(3, "\2\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 1024, 13140992) = 1024
pread64(3, "\3\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 1024, 13142016) = 1024
pread64(3, "\4\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 1024, 13143040) = 1024
pread64(3, "\5\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 1024, 13164544) = 1024
pread64(3, "\6\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 1024, 13165568) = 1024
pread64(3, "\0\0\0\0\0\0\0\0\1\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 1024, 13166592) = 1024
pread64(3, "\2\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 1024, 13153280) = 1024
pread64(3, "\3\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 1024, 13154304) = 1024
pread64(3, "\4\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 1024, 13155328) = 1024
pread64(3, "\5\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 1024, 13168640) = 1024
pread64(3, "\6\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 1024, 13169664) = 1024
pread64(3, "\0\0\0\0\0\0\0\0\1\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 1024, 13170688) = 1024
pwrite64(3, "\0\0\0\0\0\0\0\0\1\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 1024, 13166592) = 1024
pwrite64(3, "\0\0\0\0\0\0\0\0\1\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 1024, 13170688) = 1024
getrusage(RUSAGE_SELF, {ru_utime={tv_sec=0, tv_usec=44996}, ru_stime={tv_sec=0, tv_usec=548492}, ...}) = 0
write(1, "Pass 3: Checking directory conne"..., 40) = 40
getrusage(RUSAGE_SELF, {ru_utime={tv_sec=0, tv_usec=45065}, ru_stime={tv_sec=0, tv_usec=548492}, ...}) = 0
getrusage(RUSAGE_SELF, {ru_utime={tv_sec=0, tv_usec=45123}, ru_stime={tv_sec=0, tv_usec=548492}, ...}) = 0
write(1, "Pass 4a: Checking for orphaned i"..., 38) = 38
getrusage(RUSAGE_SELF, {ru_utime={tv_sec=0, tv_usec=45237}, ru_stime={tv_sec=0, tv_usec=548492}, ...}) = 0
getrusage(RUSAGE_SELF, {ru_utime={tv_sec=0, tv_usec=45351}, ru_stime={tv_sec=0, tv_usec=548492}, ...}) = 0
write(1, "Pass 4b: Checking inodes link co"..., 37) = 37
getrusage(RUSAGE_SELF, {ru_utime={tv_sec=0, tv_usec=45395}, ru_stime={tv_sec=0, tv_usec=548492}, ...}) = 0
getrusage(RUSAGE_SELF, {ru_utime={tv_sec=0, tv_usec=45426}, ru_stime={tv_sec=0, tv_usec=548492}, ...}) = 0
write(1, "Pass 5: Checking quota informati"..., 35) = 35
getrusage(RUSAGE_SELF, {ru_utime={tv_sec=0, tv_usec=45474}, ru_stime={tv_sec=0, tv_usec=548492}, ...}) = 0
brk(0x5630569a1000)                     = 0x5630569a1000
io_setup(7, [0x7f61b3404000])           = 0
io_submit(0x7f61b3404000, 7, [{aio_data=0, aio_lio_opcode=IOCB_CMD_PREAD, aio_fildes=3, aio_buf=0x563056196800, aio_nbytes=1024, aio_offset=4096}, {aio_data=0, aio_lio_opcode=IOCB_CMD_PREAD, aio_fildes=3, aio_buf=0x563056196c00, aio_nbytes=1024, aio_offset=31457280}, {aio_data=0, aio_lio_opcode=IOCB_CMD_PREAD, aio_fildes=3, aio_buf=0x563056197000, aio_nbytes=1024, aio_offset=62914560}, {aio_data=0, aio_lio_opcode=IOCB_CMD_PREAD, aio_fildes=3, aio_buf=0x563056197400, aio_nbytes=1024, aio_offset=94371840}, {aio_data=0, aio_lio_opcode=IOCB_CMD_PREAD, aio_fildes=3, aio_buf=0x563056197800, aio_nbytes=1024, aio_offset=125829120}, {aio_data=0, aio_lio_opcode=IOCB_CMD_PREAD, aio_fildes=3, aio_buf=0x563056197c00, aio_nbytes=1024, aio_offset=157286400}, {aio_data=0, aio_lio_opcode=IOCB_CMD_PREAD, aio_fildes=3, aio_buf=0x563056198000, aio_nbytes=1024, aio_offset=188743680}]) = 7
io_pgetevents(0x7f61b3404000, 7, 7, [{data=0, obj=0x56305616ffb0, res=1024, res2=0}, {data=0, obj=0x56305616ff70, res=1024, res2=0}, {data=0, obj=0x56305616ff30, res=1024, res2=0}, {data=0, obj=0x56305616fef0, res=1024, res2=0}, {data=0, obj=0x56305616feb0, res=1024, res2=0}, {data=0, obj=0x56305616fe70, res=1024, res2=0}, {data=0, obj=0x56305616fe30, res=1024, res2=0}], NULL, {sigmask=NULL, sigsetsize=8}) = 7
io_destroy(0x7f61b3404000)              = 0
pwrite64(3, "GROUP01\0\300\3\0\36q\17\0\0L\23\t<\0\0\0\0\0\0\0\0\0\0\0\0"..., 1024, 4096) = 1024
pwrite64(3, "INODE01\0L\23\t<\377\377\7\0\0\0\0\0\0\310\0\0\0\0\0\0\0\0\0\0"..., 1024, 15360) = 1024
pwrite64(3, "GROUP01\0\300\3\0\36r\17\0\0L\23\t<\0\0\0\0\0\0\0\0\0\0\0\0"..., 1024, 4096) = 1024
pwrite64(3, "INODE01\0L\23\t<\377\377\7\0\0\0\0\0\0\310\0\0\0\0\0\0\0\0\0\0"..., 1024, 15360) = 1024
pwrite64(3, "INODE01\0L\23\t<\377\377\10\0\0\0\0\0\2\0\0\0\0\0\0\0\0\0\0\0"..., 1024, 16384) = 1024
pwrite64(3, "GROUP01\0\300\3\0\36q\17\0\0L\23\t<\0\0\0\0\0\0\0\0\0\0\0\0"..., 1024, 4096) = 1024
pwrite64(3, "INODE01\0L\23\t<\377\377\7\0\0\0\0\0\0\310\0\0\0\0\0\0\0\0\0\0"..., 1024, 15360) = 1024
pwrite64(3, "INODE01\0L\23\t<\377\377\10\0\0\0\0\0\1\0\0\0\0\0\0\0\0\0\0\0"..., 1024, 16384) = 1024
pwrite64(3, "p$\365\f\0\0\0\0\200:\t\0\200:\t\0\20'\0\0\2\0\0\0\0\0\0\0\0\0\0\0"..., 1024, 13139968) = 1024
pwrite64(3, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 1024, 13140992) = 1024
pwrite64(3, "GROUP01\0\300\3\0\36p\17\0\0L\23\t<\0\0\0\0\0\0\0\0\0\0\0\0"..., 1024, 4096) = 1024
pwrite64(3, "INODE01\0L\23\t<\377\377\7\0\0\0\0\0\0\310\0\0\0\0\0\0\0\0\0\0"..., 1024, 15360) = 1024
pwrite64(3, "INODE01\0L\23\t<\377\377\10\0\0\0\0\0\2\0\0\0\0\0\0\0\0\0\0\0"..., 1024, 16384) = 1024
pwrite64(3, "\0\0\0\0\0\0\0\0\1\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 1024, 13166592) = 1024
pwrite64(3, "\6\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 1024, 13165568) = 1024
pwrite64(3, "\5\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 1024, 13164544) = 1024
pwrite64(3, "\4\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 1024, 13143040) = 1024
pwrite64(3, "\3\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 1024, 13142016) = 1024
pwrite64(3, "\2\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 1024, 13140992) = 1024
pwrite64(3, "\0\0\0\0\0\0\0\0\1\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 1024, 13166592) = 1024
pwrite64(3, "GROUP01\0\300\3\0\36q\17\0\0L\23\t<\0\0\0\0\0\0\0\0\0\0\0\0"..., 1024, 4096) = 1024
pwrite64(3, "INODE01\0L\23\t<\377\377\7\0\0\0\0\0\0\310\0\0\0\0\0\0\0\0\0\0"..., 1024, 15360) = 1024
pwrite64(3, "INODE01\0L\23\t<\377\377\26\0\0\0\0\0\1\0\0\0\0\0\0\0\0\0\0\0"..., 1024, 30720) = 1024
pwrite64(3, "INODE01\0L\23\t<\377\377\26\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 1024, 30720) = 1024
pwrite64(3, "GROUP01\0\300\3\0\36p\17\0\0L\23\t<\0\0\0\0\0\0\0\0\0\0\0\0"..., 1024, 4096) = 1024
pwrite64(3, "INODE01\0L\23\t<\377\377\7\0\0\0\0\0\0\310\0\0\0\0\0\0\0\0\0\0"..., 1024, 15360) = 1024
pwrite64(3, "INODE01\0L\23\t<\377\377\26\0\0\0\0\0\1\0\0\0\0\0\0\0\0\0\0\0"..., 1024, 30720) = 1024
pwrite64(3, "INODE01\0L\23\t<\377\377\26\0\0\0\0\0\1\0\0\0\0\0\0\0\0\0\0\0"..., 1024, 30720) = 1024
pwrite64(3, "\300$\365\f\0\0\0\0\1\0\0\0\1\0\0\0\2\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 2048, 13144064) = 2048
pwrite64(3, "GROUP01\0\300\3\0\36q\17\0\0L\23\t<\0\0\0\0\0\0\0\0\0\0\0\0"..., 1024, 4096) = 1024
pwrite64(3, "INODE01\0L\23\t<\377\377\7\0\0\0\0\0\0\310\0\0\0\0\0\0\0\0\0\0"..., 1024, 15360) = 1024
pwrite64(3, "INODE01\0L\23\t<\377\377\27\0\0\0\0\0\1\0\0\0\0\0\0\0\0\0\0\0"..., 1024, 31744) = 1024
pwrite64(3, "INODE01\0L\23\t<\377\377\27\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 1024, 31744) = 1024
pwrite64(3, "GROUP01\0\300\3\0\36p\17\0\0L\23\t<\0\0\0\0\0\0\0\0\0\0\0\0"..., 1024, 4096) = 1024
pwrite64(3, "INODE01\0L\23\t<\377\377\7\0\0\0\0\0\0\310\0\0\0\0\0\0\0\0\0\0"..., 1024, 15360) = 1024
pwrite64(3, "INODE01\0L\23\t<\377\377\27\0\0\0\0\0\1\0\0\0\0\0\0\0\0\0\0\0"..., 1024, 31744) = 1024
pwrite64(3, "INODE01\0L\23\t<\377\377\27\0\0\0\0\0\1\0\0\0\0\0\0\0\0\0\0\0"..., 1024, 31744) = 1024
pwrite64(3, "\300$\365\f\0\0\0\0\1\0\0\0\1\0\0\0\2\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 2048, 13148160) = 2048
pwrite64(3, "GROUP01\0\300\3\0\36q\17\0\0L\23\t<\0\0\0\0\0\0\0\0\0\0\0\0"..., 1024, 4096) = 1024
pwrite64(3, "INODE01\0L\23\t<\377\377\7\0\0\0\0\0\0\310\0\0\0\0\0\0\0\0\0\0"..., 1024, 15360) = 1024
pwrite64(3, "GROUP01\0\300\3\0\36r\17\0\0L\23\t<\0\0\0\0\0\0\0\0\0\0\0\0"..., 1024, 4096) = 1024
pwrite64(3, "INODE01\0L\23\t<\377\377\7\0\0\0\0\0\0\310\0\0\0\0\0\0\0\0\0\0"..., 1024, 15360) = 1024
pwrite64(3, "INODE01\0L\23\t<\377\377\t\0\0\0\0\0\2\0\0\0\0\0\0\0\0\0\0\0"..., 1024, 17408) = 1024
pwrite64(3, "GROUP01\0\300\3\0\36q\17\0\0L\23\t<\0\0\0\0\0\0\0\0\0\0\0\0"..., 1024, 4096) = 1024
pwrite64(3, "INODE01\0L\23\t<\377\377\7\0\0\0\0\0\0\310\0\0\0\0\0\0\0\0\0\0"..., 1024, 15360) = 1024
pwrite64(3, "INODE01\0L\23\t<\377\377\t\0\0\0\0\0\1\0\0\0\0\0\0\0\0\0\0\0"..., 1024, 17408) = 1024
pwrite64(3, "q$\365\f\0\0\0\0\200:\t\0\200:\t\0\20'\0\0\2\0\0\0\0\0\0\0\0\0\0\0"..., 1024, 13152256) = 1024
pwrite64(3, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 1024, 13153280) = 1024
pwrite64(3, "GROUP01\0\300\3\0\36p\17\0\0L\23\t<\0\0\0\0\0\0\0\0\0\0\0\0"..., 1024, 4096) = 1024
pwrite64(3, "INODE01\0L\23\t<\377\377\7\0\0\0\0\0\0\310\0\0\0\0\0\0\0\0\0\0"..., 1024, 15360) = 1024
pwrite64(3, "INODE01\0L\23\t<\377\377\t\0\0\0\0\0\2\0\0\0\0\0\0\0\0\0\0\0"..., 1024, 17408) = 1024
pwrite64(3, "\0\0\0\0\0\0\0\0\1\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 1024, 13170688) = 1024
pwrite64(3, "\6\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 1024, 13169664) = 1024
pwrite64(3, "\5\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 1024, 13168640) = 1024
pwrite64(3, "\4\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 1024, 13155328) = 1024
pwrite64(3, "\3\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 1024, 13154304) = 1024
pwrite64(3, "\2\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 1024, 13153280) = 1024
pwrite64(3, "\0\0\0\0\0\0\0\0\1\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 1024, 13170688) = 1024
pwrite64(3, "GROUP01\0\300\3\0\36q\17\0\0L\23\t<\0\0\0\0\0\0\0\0\0\0\0\0"..., 1024, 4096) = 1024
pwrite64(3, "INODE01\0L\23\t<\377\377\7\0\0\0\0\0\0\310\0\0\0\0\0\0\0\0\0\0"..., 1024, 15360) = 1024
pwrite64(3, "INODE01\0L\23\t<\377\377\30\0\0\0\0\0\1\0\0\0\0\0\0\0\0\0\0\0"..., 1024, 32768) = 1024
pwrite64(3, "INODE01\0L\23\t<\377\377\30\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 1024, 32768) = 1024
pwrite64(3, "GROUP01\0\300\3\0\36p\17\0\0L\23\t<\0\0\0\0\0\0\0\0\0\0\0\0"..., 1024, 4096) = 1024
pwrite64(3, "INODE01\0L\23\t<\377\377\7\0\0\0\0\0\0\310\0\0\0\0\0\0\0\0\0\0"..., 1024, 15360) = 1024
pwrite64(3, "INODE01\0L\23\t<\377\377\30\0\0\0\0\0\1\0\0\0\0\0\0\0\0\0\0\0"..., 1024, 32768) = 1024
pwrite64(3, "INODE01\0L\23\t<\377\377\30\0\0\0\0\0\1\0\0\0\0\0\0\0\0\0\0\0"..., 1024, 32768) = 1024
pwrite64(3, "\301$\365\f\0\0\0\0\1\0\0\0\1\0\0\0\2\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 2048, 13156352) = 2048
pwrite64(3, "GROUP01\0\300\3\0\36q\17\0\0L\23\t<\0\0\0\0\0\0\0\0\0\0\0\0"..., 1024, 4096) = 1024
pwrite64(3, "INODE01\0L\23\t<\377\377\7\0\0\0\0\0\0\310\0\0\0\0\0\0\0\0\0\0"..., 1024, 15360) = 1024
pwrite64(3, "INODE01\0L\23\t<\377\377\31\0\0\0\0\0\1\0\0\0\0\0\0\0\0\0\0\0"..., 1024, 33792) = 1024
pwrite64(3, "INODE01\0L\23\t<\377\377\31\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 1024, 33792) = 1024
pwrite64(3, "GROUP01\0\300\3\0\36p\17\0\0L\23\t<\0\0\0\0\0\0\0\0\0\0\0\0"..., 1024, 4096) = 1024
pwrite64(3, "INODE01\0L\23\t<\377\377\7\0\0\0\0\0\0\310\0\0\0\0\0\0\0\0\0\0"..., 1024, 15360) = 1024
pwrite64(3, "INODE01\0L\23\t<\377\377\31\0\0\0\0\0\1\0\0\0\0\0\0\0\0\0\0\0"..., 1024, 33792) = 1024
pwrite64(3, "INODE01\0L\23\t<\377\377\31\0\0\0\0\0\1\0\0\0\0\0\0\0\0\0\0\0"..., 1024, 33792) = 1024
pwrite64(3, "\301$\365\f\0\0\0\0\1\0\0\0\1\0\0\0\2\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 2048, 13160448) = 2048
getrusage(RUSAGE_SELF, {ru_utime={tv_sec=0, tv_usec=55343}, ru_stime={tv_sec=0, tv_usec=548492}, ...}) = 0
write(1, "All passes succeeded.\n", 22) = 22
write(1, "\n", 1)                       = 1
pwrite64(3, "OCFSV2\0\0L\23\t<\377\377\377\377\0\0\0\0\0\310\0\0\0\0\0\0\0\0\0\0"..., 1024, 2048) = 1024
pwrite64(3, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096, 13135872) = 4096
rt_sigprocmask(SIG_BLOCK, ~[TRAP SEGV RTMIN RT_1], NULL, 8) = 0
write(5, "\6\0\0\0\0\0\0\0\2\0\0\0\2\1\355\376\20\0\0\0\10\0\0\0\2\0\0\0\377\377\377\377"..., 120) = 0
read(5, "\6\0\0\0\0\0\0\0\2\0\0\0H\0\0\0\20\243?\263a\177\0\0\0\0\0\0\0\0\0\0"..., 104) = 72
write(5, "\6\0\0\0\0\0\0\0\2\0\0\0\2\1\0\0 \0\230\304\10\0\0\0\1\0\0\0\310\16\355\376"..., 120) = 0
read(5, "\6\0\0\0\0\0\0\0\2\0\0\0H\0\0\0\20\243?\263a\177\0\0\0\0\0\0\0\0\0\0"..., 104) = 72
newfstatat(AT_FDCWD, "/dev/misc/dlm_48E8C81F039C4F5E9CC099C954C14D46", {st_mode=S_IFLNK|0777, st_size=39, ...}, AT_SYMLINK_NOFOLLOW) = 0
newfstatat(5, "", {st_mode=S_IFCHR|0600, st_rdev=makedev(0xa, 0x79), ...}, AT_EMPTY_PATH) = 0
close(5)                                = 0
fcntl(4, F_SETFD, FD_CLOEXEC)           = 0
write(4, "\6\0\0\0\0\0\0\0\2\0\0\0\5\1\0\0\0\0\0\0y\0\0\0\4\0\0\0\0\0\0\0"..., 120) = -1 EBUSY (Device or resource busy)
openat(AT_FDCWD, "/dev/misc/dlm_48E8C81F039C4F5E9CC099C954C14D46", O_RDWR) = 5
close(5)                                = 0
openat(AT_FDCWD, "/dev/loop0", O_RDONLY) = 5
ioctl(5, BLKSSZGET, [512])              = 0
close(5)                                = 0
openat(AT_FDCWD, "/sys/fs/ocfs2/dlm_recover_callback_support", O_RDONLY) = 5
newfstatat(5, "", {st_mode=S_IFREG|0444, st_size=4096, ...}, AT_EMPTY_PATH) = 0
read(5, "1\n", 4096)                    = 2
close(5)                                = 0
rt_sigprocmask(SIG_UNBLOCK, ~[TRAP SEGV RTMIN RT_1], NULL, 8) = 0
pwrite64(3, "p$\365\f\0\0\0\0\200:\t\0\200:\t\0\20'\0\0\7\0\0\0\0\0\0\0\6\0\0\0"..., 1024, 13139968) = 1024
pwrite64(3, "INODE01\0L\23\t<\377\377\10\0\0\0\0\0\2\0\0\0\0\0\0\0\0\0\0\0"..., 1024, 16384) = 1024
pwrite64(3, "q$\365\f\0\0\0\0\200:\t\0\200:\t\0\20'\0\0\7\0\0\0\0\0\0\0\6\0\0\0"..., 1024, 13152256) = 1024
pwrite64(3, "INODE01\0L\23\t<\377\377\t\0\0\0\0\0\2\0\0\0\0\0\0\0\0\0\0\0"..., 1024, 17408) = 1024
munlock(0x563054cd9800, 20148224)       = 0
munlock(0x563056010a90, 1259264)        = 0
close(3)                                = 0
exit_group(0)                           = ?
+++ exited with 0 +++

--9Kt8mU6uY+Ra0oRv--
