Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc255.phx1.oracleemaildelivery.com (aib29ajc255.phx1.oracleemaildelivery.com [192.29.103.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A6B28CCA47B
	for <ocfs2-devel@archiver.kernel.org>; Fri, 10 Jun 2022 10:17:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=1s53Ra40TVrW3nj0gIzRwtm+O+F6AsjUcstnOoNL4GU=;
 b=q9ukLucjyoyDo5uPRtCnRtfPOMCwwWkb32e1m+c3tZMkrMpz6EoBJSOBg2Hwve7iF7uXwHRnqECK
   r5DN+5i0BfzdEzxj7zUEQoEin1kf/ReQUx3m+Qvtc9f11y1EQMPB9sL7WGVdkq3R1DGbVV0huWiu
   rjTRC92V1RiyyplBIM4GUCQyMq3Ry6l64de/2PNSu/Urni+SSuu3A2Ofnt1jk93Xs3qzjiHI0TtS
   t60TKX5p0vitPzC2z/ZzgNJ09VKd8DG5V8M9v+8HmY7x/sJc62x5tGDOSPuUhAnvNhuPH1r6fGrq
   CAmUrC8I3KH8zR7xn6Wg54XQYP0063dT2nOFbg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=1s53Ra40TVrW3nj0gIzRwtm+O+F6AsjUcstnOoNL4GU=;
 b=Hz0CUW4dlRJGVRlIH7gW7TZFibtEUABOd/55h1Jb3Ps2J00p3U+zRVdXk1axB+i6pYSvPr/eaz7R
   xUsypOlb2qSJtlyG4Y/gTOOxs6TmyJq28gdZRnENoTS4HViLrXaGoTZYkMV8ytps+FTmeYnehR0I
   oiAEpG6xeJb+Fd6BcDveKG742JpJUltqsaxtWeV+BINdkEFZHi4vunjCUZ26V+St3f0huQ1ZhIXV
   vwkma9dqUxNnoHxcNyK35pvhreE2l0WE5AhwPa+OYEfzQKCUI5zyaspxkfTFXqExVDBJVHE9i85T
   +Foaydyu0ElBeyJaactVQXdSxysn4BhTeoaXNg==
Received: by omta-ad3-fd3-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220517 64bit (built May 17
 2022))
 with ESMTPS id <0RD9002Q5B9QBN90@omta-ad3-fd3-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Fri, 10 Jun 2022 10:17:50 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1654856257;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=Ekvjf5YPr7Sjtvmnh5pMqvNXgm63w4q321GSzdMpiws=;
 b=R422DQNibOldKWlgmARWqJj/jnBflxYGCJ34dPCeAmqGiPs+R8ZIsaALOJs26KSF7i5shV
 8c4iGAzs36ZifLrsLUUvTTYBlEKMNjAuWAXnLpu9z/IiIszg0EPqkub8BmaIO/xtiimXrM
 E/8YUE26JcZOBvyiHFzLj8IJXPCzQcQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=1e100.net;
 s=20210112;
 h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
 :content-language:to:cc:references:from:organization:in-reply-to
 :content-transfer-encoding; bh=Ekvjf5YPr7Sjtvmnh5pMqvNXgm63w4q321GSzdMpiws=;
 b=xQh6ip6JmhX58Cv+ioLdRidJfjFqZlKCKD56MTmB1Rjjq6DRjYXXy+rdv5/Jqlrabm
 HMzMRX+CBhPOQE+X+h2LBxdhL5uEXP/CzpoP285wH6o+DyXhD8o32g1oz3gZIddY2yRO
 TQrgz7GwzJa1NgjeDJHyNxlYObvbW/tLKAiVG0dNTE7z7DVmqneY8A3I9iqKrP0Osp6E
 G5tnrGuM7iShKJGT9WZx7oKPdDqDJOX4ebPkfdASrwCGg3jvCsrWkZA1Wjo+0CkVkIEs
 ib8FPf2m5A/GFYKcK5p4Q6vBfGeFHkEShdJNYw9ioMNxZEG3lLe/f3e1wgDeyENtXmJY gvrQ==
X-Gm-Message-State: AOAM531wpoAmsLCGVVwTUB8AA4k66USqobwMJGx0PAYvw9IGVnqG9N3F
 NJfEFVQIB7SpVvZ/Ev5WpPv8Y6AH/eCJsvZFlXFJCu7+hnSDIQgMqz7gTAmkTqZgTVX51TZ+mt3
 QGJ93a23bM7I+5LabTbTOgg==
X-Received: by 2002:a05:6000:91:b0:217:8efc:f572 with SMTP id
 m17-20020a056000009100b002178efcf572mr29122731wrx.186.1654856255658; Fri,
 10 Jun 2022 03:17:35 -0700 (PDT)
X-Received: by 2002:a05:6000:91:b0:217:8efc:f572 with SMTP id
 m17-20020a056000009100b002178efcf572mr29122693wrx.186.1654856255339; Fri,
 10 Jun 2022 03:17:35 -0700 (PDT)
Message-id: <e287a12d-29d9-da69-9315-52414341cbd1@redhat.com>
Date: Fri, 10 Jun 2022 12:17:33 +0200
MIME-version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
To: Matthew Wilcox <willy@infradead.org>
References: <20220608150249.3033815-1-willy@infradead.org>
 <20220608150249.3033815-4-willy@infradead.org>
 <b2a81248-03fc-afb3-1041-d8206e95e08a@redhat.com>
 <YqIFHPJZNMrmtXlh@casper.infradead.org>
Organization: Red Hat
In-reply-to: <YqIFHPJZNMrmtXlh@casper.infradead.org>
Authentication-results: relay.mimecast.com; auth=pass smtp.auth=CUSA124A263
 smtp.mailfrom=david@redhat.com
Content-language: en-US
X-Source-IP: 170.10.129.124
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10373
 signatures=594849
Cc: linux-aio@kvack.org, linux-nfs@vger.kernel.org, cluster-devel@redhat.com,
 linux-ntfs-dev@lists.sourceforge.net, linux-kernel@vger.kernel.org,
 linux-f2fs-devel@lists.sourceforge.net, linux-block@vger.kernel.org,
 linux-mm@kvack.org, linux-mtd@lists.infradead.org, ocfs2-devel@oss.oracle.com,
 linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
 virtualization@lists.linux-foundation.org, linux-xfs@vger.kernel.org,
 linux-btrfs@vger.kernel.org
Subject: Re: [Ocfs2-devel] [PATCH v2 03/19] fs: Add aops->migrate_folio
X-BeenThere: ocfs2-devel@oss.oracle.com
X-Mailman-Version: 2.1.15
Precedence: list
List-Id: <ocfs2-devel.oss.oracle.com>
List-Unsubscribe: <https://oss.oracle.com/mailman/options/ocfs2-devel>,
 <mailto:ocfs2-devel-request@oss.oracle.com?subject=unsubscribe>
List-Archive: <http://oss.oracle.com/pipermail/ocfs2-devel/>
List-Post: <mailto:ocfs2-devel@oss.oracle.com>
List-Help: <mailto:ocfs2-devel-request@oss.oracle.com?subject=help>
List-Subscribe: <https://oss.oracle.com/mailman/listinfo/ocfs2-devel>,
 <mailto:ocfs2-devel-request@oss.oracle.com?subject=subscribe>
From: David Hildenbrand via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: David Hildenbrand <david@redhat.com>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-MC-Unique: -aX4_s8YO7K7UebPJR7k-Q-1
X-Google-Smtp-Source:
 ABdhPJzMoCknlizO69Nl0wuEIzBALIZP/2+KDolU3ne+3dmHgzec6LJk/2XhtTIsrJ35XnXVn7hgfw==
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:103.23.64.2 ip4:103.23.65.2
 ip4:103.23.66.26 ip4:103.23.67.26 ip4:107.21.15.141 ip4:108.177.8.0/21
 ip4:128.17.0.0/20 ip4:128.17.128.0/20 ip4:128.17.192.0/20 ip4:128.17.64.0/20
 ip4:128.245.0.0/20 ip4:128.245.64.0/20 ip4:13.110.208.0/21 ip4:13.110.216.0/22
 ip4:13.110.224.0/20 ip4:13.111.0.0/16 ip4:136.147.128.0/20
 include:spf1.redhat.com -all
X-Proofpoint-SPF-VenPass: Allowed
X-ServerName: us-smtp-delivery-124.mimecast.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:103.23.64.2 ip4:103.23.65.2
 ip4:103.23.66.26 ip4:103.23.67.26 ip4:107.21.15.141 ip4:108.177.8.0/21
 ip4:128.17.0.0/20 ip4:128.17.128.0/20 ip4:128.17.192.0/20 ip4:128.17.64.0/20
 ip4:128.245.0.0/20 ip4:128.245.64.0/20 ip4:13.110.208.0/21 ip4:13.110.216.0/22
 ip4:13.110.224.0/20 ip4:13.111.0.0/16 ip4:136.147.128.0/20
 include:spf1.redhat.com -all
X-Proofpoint-Spam-Reason: safe
X-Spam: OrgSafeList
X-SpamRule: orgsafelist
X-Proofpoint-GUID: Nrw3-Z5Ikb8C1YePSjoalDdMHngokqK9
X-Proofpoint-ORIG-GUID: Nrw3-Z5Ikb8C1YePSjoalDdMHngokqK9
Reporting-Meta:
 AAFChV3F+yB2AzkhWAqkrphmNmDq+6KvNO+hYpW46tWeZwcBLHxzNKwUXvqQzQpw
 stXa5RjFFkBMfmjgH5zgDy8SvRTTtVf7xscC/yfOimh4zXwoZ+UXsCD519fpipAE
 rraLpwUVc5ULFWLjjm+5xTedzoHyOoNpoJEBFbBuUr/JPB4Ux+ve+hqCmJgBXzYK
 GlmiR8Df7Caa1TnsCjBsgAexcZdgiNv0nKnvv5JdYQbuhnXvSuv37jy6Qdn2J7Nc
 Gku5WjmV/ArWkcRWlT8X8DL2LAeN0dOJgFXO8jOChDBAWPlwtw50TPKLTHssyz15
 v3NktT4HJekaVjARO/p6lYmPL14JLGcBw6eZsathqr6PDQ++3/bw+NUqHazalpKi
 ziUMamwNNEyT4GN3s6ttuN5VVSbPH6I4JoPyCbpaudY2ShFSqShbaM9sRSQb2gz5
 DdOgcZBHsrXvzBxDdTB/p/TLMshbBmvx3cny6HK+mUJ4J0SD24rO06+4vP+d9Vjk
 cQOUvamlAVSl10YwnU6c5GQJLvpdifcpyBkdI1nO/XM=

On 09.06.22 16:35, Matthew Wilcox wrote:
> On Thu, Jun 09, 2022 at 02:50:20PM +0200, David Hildenbrand wrote:
>> On 08.06.22 17:02, Matthew Wilcox (Oracle) wrote:
>>> diff --git a/Documentation/filesystems/locking.rst b/Documentation/filesystems/locking.rst
>>> index c0fe711f14d3..3d28b23676bd 100644
>>> --- a/Documentation/filesystems/locking.rst
>>> +++ b/Documentation/filesystems/locking.rst
>>> @@ -253,7 +253,8 @@ prototypes::
>>>  	void (*free_folio)(struct folio *);
>>>  	int (*direct_IO)(struct kiocb *, struct iov_iter *iter);
>>>  	bool (*isolate_page) (struct page *, isolate_mode_t);
>>> -	int (*migratepage)(struct address_space *, struct page *, struct page *);
>>> +	int (*migrate_folio)(struct address_space *, struct folio *dst,
>>> +			struct folio *src, enum migrate_mode);
>>>  	void (*putback_page) (struct page *);
>>
>> isolate_page/putback_page are leftovers from the previous patch, no?
> 
> Argh, right, I completely forgot I needed to update the documentation in
> that patch.
> 
>>> +++ b/Documentation/vm/page_migration.rst
>>> @@ -181,22 +181,23 @@ which are function pointers of struct address_space_operations.
>>>     Once page is successfully isolated, VM uses page.lru fields so driver
>>>     shouldn't expect to preserve values in those fields.
>>>  
>>> -2. ``int (*migratepage) (struct address_space *mapping,``
>>> -|	``struct page *newpage, struct page *oldpage, enum migrate_mode);``
>>> -
>>> -   After isolation, VM calls migratepage() of driver with the isolated page.
>>> -   The function of migratepage() is to move the contents of the old page to the
>>> -   new page
>>> -   and set up fields of struct page newpage. Keep in mind that you should
>>> -   indicate to the VM the oldpage is no longer movable via __ClearPageMovable()
>>> -   under page_lock if you migrated the oldpage successfully and returned
>>> -   MIGRATEPAGE_SUCCESS. If driver cannot migrate the page at the moment, driver
>>> -   can return -EAGAIN. On -EAGAIN, VM will retry page migration in a short time
>>> -   because VM interprets -EAGAIN as "temporary migration failure". On returning
>>> -   any error except -EAGAIN, VM will give up the page migration without
>>> -   retrying.
>>> -
>>> -   Driver shouldn't touch the page.lru field while in the migratepage() function.
>>> +2. ``int (*migrate_folio) (struct address_space *mapping,``
>>> +|	``struct folio *dst, struct folio *src, enum migrate_mode);``
>>> +
>>> +   After isolation, VM calls the driver's migrate_folio() with the
>>> +   isolated folio.  The purpose of migrate_folio() is to move the contents
>>> +   of the source folio to the destination folio and set up the fields
>>> +   of destination folio.  Keep in mind that you should indicate to the
>>> +   VM the source folio is no longer movable via __ClearPageMovable()
>>> +   under folio if you migrated the source successfully and returned
>>> +   MIGRATEPAGE_SUCCESS.  If driver cannot migrate the folio at the
>>> +   moment, driver can return -EAGAIN. On -EAGAIN, VM will retry folio
>>> +   migration in a short time because VM interprets -EAGAIN as "temporary
>>> +   migration failure".  On returning any error except -EAGAIN, VM will
>>> +   give up the folio migration without retrying.
>>> +
>>> +   Driver shouldn't touch the folio.lru field while in the migrate_folio()
>>> +   function.
>>>  
>>>  3. ``void (*putback_page)(struct page *);``
>>
>> Hmm, here it's a bit more complicated now, because we essentially have
>> two paths: LRU+migrate_folio or !LRU+movable_ops
>> (isolate/migrate/putback page)
> 
> Oh ... actually, this is just documenting the driver side of things.
> I don't really like how it's written.  Here, have some rewritten
> documentation (which is now part of the previous patch):
> 

LGTM, thanks.


-- 
Thanks,

David / dhildenb


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
