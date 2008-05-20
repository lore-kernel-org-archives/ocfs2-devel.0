From: Louis Rilling <Louis.Rilling@kerlabs.com>
Date: Tue, 20 May 2008 19:08:54 +0200
Subject: [Ocfs2-devel] [RFC][PATCH 0/3] configfs: Make nested default
	groups lockdep-friendly
In-Reply-To: <20080520095810.1d50d247@infradead.org>
References: <20080520163320.025971210@kerlabs.com>
	<20080520095810.1d50d247@infradead.org>
Message-ID: <483305A6.3040906@kerlabs.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Arjan van de Ven <arjan@infradead.org>
Cc: Joel.Becker@oracle.com, linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com

Arjan van de Ven a ?crit :
> On Tue, 20 May 2008 18:33:20 +0200
> Louis Rilling <Louis.Rilling@kerlabs.com> wrote:
> 
>> Hi all,
>>
>> The following patches fix lockdep warnings resulting from (correct)
>> recursive locking in configfs.
>>
>> Current lockdep annotations for inode mutexes in configfs are
>> lockdep-friendly provided that:
>> 1/ config_groups have at most one level of default groups (see
>>    configfs_attach_group()),
>> 2/ config_groups having default groups are never removed (see
>>    configfs_detach_prep()).
>>
>> Since lockdep does not handle such correct recursion, the idea is to
>> insert lockdep_off()/lockdep_on() for inode mutexes as soon as the
>> level of recursion of the I_MUTEX_PARENT -> I_MUTEX_CHILD dependency
>> pattern increases.
> 
> I'm... not entirely happy with such a solution ;(
> 
> there must be a better one.

Hmm, to me there are three solutions:

1/ keep lockdep and configfs like they are, and use this patchset

2/ enhance lockdep to handle wariable-depth but correct recursion:
seems uncertain...


3/ remove this recursive locking from configfs:
unfortunately, it seems that there are a good reasons for doing
recursive inode locking, at least when removing a config_group with
default groups. So, seems uncertain too...

Other ideas?

-- 
Dr Louis Rilling			Kerlabs
Skype: louis.rilling			Batiment Germanium
Phone: (+33|0) 6 80 89 08 23		80 avenue des Buttes de Coesmes
http://www.kerlabs.com/			35700 Rennes
