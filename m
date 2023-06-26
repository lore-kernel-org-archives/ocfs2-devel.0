Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc250.phx1.oracleemaildelivery.com (aib29ajc250.phx1.oracleemaildelivery.com [192.29.103.250])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1A88FEB64DC
	for <ocfs2-devel@archiver.kernel.org>; Mon, 26 Jun 2023 15:09:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=2BGnAAXTbmWeCwTQz8+QMZEQ0qyjENjSEKOR9LyuKaU=;
 b=zzW5qyMfS4UgEEmuoMw0bHHHvlJDHEQq/uDIlQfpv5G3NVbFkqhnpeaJttACRdSvrM2UX+2HBj8V
   52F0UqpQDcZy2YVTKzOPowF8kHvZVjMoIfVthgSFNYJd2fjb76DvU8cWMxR+88AVbBO79m8O+wa7
   9fvGlEQ1R9tN49eMsNWX3Q4/mHlP8NH/JQQZNVY6+u2DKUqsxH740cOprIb7lPBmQBS8YgBAdrrp
   1tPRO7Emnp+lvIY6SP2pmoEQLpG5FHAq9vTB+TrCwn6CuV9Ko1pIZMl2X+dOBrIjQN0zViR5N7V6
   2kuCPvekW+3x/wjUBihhbKJxc7f7af3+lGQAeg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=2BGnAAXTbmWeCwTQz8+QMZEQ0qyjENjSEKOR9LyuKaU=;
 b=qRt9ocszZJqeYwvx7ObaFS1OEaFXvKH3eMbOWW8p48Tmx2dJ34/7ePDNau69Vo1ts3pUF5BRi4dE
   092IeO7FFC7YN3xrjKO8CL6OU5QIs9yEvFnAUhls+ZwRyQGA1rvIhie+L5WRxBrwIQXhcNkzh8X2
   7MNlLUnx15qCRo3mfWZVQwx477BQmobiPb5aLetz/U5W7O2Ptx4w7ydr/PyFMe8nxRQ9z2qJOPh7
   Idg37EvJxO+Yqk4hVXBaKr90oMm0E/1Gf3iZ8Hkl2NSVVK0/O0Je73sL4WSVDcTma0uCKoPzpBuD
   i4DshmFiHKbvB/CN+ouHQLbcSMkwVjkP4BZslA==
Received: by omta-ad2-fd3-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230523 64bit (built May 23
 2023))
 with ESMTPS id <0RWV0065X8S4J6E0@omta-ad2-fd3-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Mon, 26 Jun 2023 15:09:41 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hsE0656vqgWOPR+q6iqZoXYKBjcxGKmH5XU81AFmKOglZqTMN1LnY+/nR+5NQ7NoEGrk3cfRYaSRGJd6cuaRsSrtaKvZYKpljWeSZvdH+w5vowVfyGPsytJ/1v4ye78WMrwhMQvB8QXhWoB9gRtHYQcDvs+/UAZN1VtdMAVXuNGhVBSbxZbURqif+D/6UZ1yBXwQWvx1e4nwBvkTAX1g6i4EXZG0JVzBZ5nCDhqPeupoYNEsar8R06cpyhhjGWVi2Vt9aZdAIG4bF6ANZP+JF8FZBjW7E0RPTxmQoz4FxksMd4P6rLtYDoR9ZDAvCtQMeSDToFdnhWDJ6u1uZACO9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iyrHrujzNMAfV+xvwJwj+FQ2LoJ+m7eMLFiZhab4cfA=;
 b=LGO5dhX7yhDpHrivtArZ1Lgzf2qAHSZFzR0jfGqF9+IBbSE3J/ddFNjxAhQvRKDEwni7o59fb6qiuWHSiyolpPzF4O0E6NcUAeg9xzEkDvkZQQV0T5ZMEel+PereE0zHsEXNIocTV//mU40es0C8FHEhhlL/0+8FlxBA+9WawpLfXBlRss3L4nTouQXRfGdeDd7kdqOpWGfH9GSmVKMgdE6hpkaR30r6bJ9odzbcPNQ44R7sIEo8YNGEkwkK/+w/d9oKj0KT/Zu1VqO0zIArttk4OSCi2XxGP5BtTHOZJOd/W0jpIJSiYEnckvoZW44M/XUtGBv2cUilifOyVPXTKA==
ARC-Authentication-results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com; dkim=pass
 header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iyrHrujzNMAfV+xvwJwj+FQ2LoJ+m7eMLFiZhab4cfA=;
 b=S710dbCEY3lXR5es0p/V6Om0eXp8W3mU/XEZOffajbwpubCQCrObms1oEyBUetg30XQZChrXEuswGKQpRZkjjNTA2hJc/TNXAEUOafiXa9S6xEq2NfsmxaC+2whSZAZoMeTet+O9G5IaGPXwWTYZA9hcLGFUuI2oDaKKviq2guPKYZYJFAyJ9EB2EL0PTbgtMdyS4JD7l8uTOxRhynDHYX9cx+1W9nfE1RLvvoooIK/4X8rrRZ2Qt4O0hU16SbN8vYoTD7jVzakte7Hm4Dr02atGUewCoeIhzjzez2b3b9GVoW9XuFKFyixodRVr120o6noctigr3oU+cYepwn4C3g==
Date: Mon, 26 Jun 2023 23:09:16 +0800
To: joseph.qi@linux.alibaba.com
Message-id: <20230626150916.je3egonzb3crvbl5@p15>
References: <20230626112453.22571-1-heming.zhao@suse.com>
Content-disposition: inline
In-reply-to: <20230626112453.22571-1-heming.zhao@suse.com>
MIME-version: 1.0
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:PA4PR04MB7997.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230028)(7916004)(366004)(396003)(346002)(376002)(136003)(39860400002)(451199021)(2906002)(33716001)(6486002)(6666004)(38100700002)(83380400001)(6506007)(26005)(186003)(9686003)(966005)(86362001)(41300700001)(478600001)(66476007)(66556008)(6916009)(66946007)(4326008)(316002)(8936002)(1076003)(6512007)(44832011)(8676002)(5660300002); DIR:OUT; SFP:1101;
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jun 2023 15:09:23.4577 (UTC)
X-Source-IP: 40.107.105.77
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10753
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 clxscore=163
 lowpriorityscore=0 priorityscore=149 impostorscore=0 mlxlogscore=999
 suspectscore=0 mlxscore=0 malwarescore=0 adultscore=0 bulkscore=0 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2306260117 domainage_hfrom=9771
Cc: ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH v2] ocfs2: add error handling path when jbd2
 enter ABORT status
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
From: Heming Zhao via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Heming Zhao <heming.zhao@suse.com>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-ClientProxiedBy: SI2PR02CA0053.apcprd02.prod.outlook.com
 (2603:1096:4:196::16) To PA4PR04MB7997.eurprd04.prod.outlook.com
 (2603:10a6:102:c9::6)
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PA4PR04MB7997:EE_|AM9PR04MB8746:EE_
X-MS-Office365-Filtering-Correlation-Id: 2cd03e54-a1a1-49b8-d3a4-08db7657531f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
 xyw9xdjcT1pIVuIcKZeogx35Tc90x0ESZvnZwfKVn7k631jOTr5VTD2WczkyIcVeZJ8HpCxKCyMmI7XebH2vXmKT6kqQ8hPkZaMbdIePOhf0/xpdgn7iVlezl0ExcKg5s1hlE3IhHZbWr6jHe2cA/+7zUtirUl42lSBSB3EhSDYPYKNxY1qF+n9iZ8/z7SsVoOwBXvXHKNKuB50uE/sXTsmbGyovl+alKI8tok9/9BlwJmqczmGilKT01tqqan0dS19kDoKt1Ok9s5bsLH7R3SHkTcYBqjLfyZ+NsTJ8IHaW2C/GyRj4lqbz3M1gJo+VMmCZelJhvr03XWJn6eLFP6dn/paraz4R6rWWq6TSW03tawrymMS4kkhejXAJzgMQ70RBXFWYKUWybLb/kevGxQD5HCb4aAVfNrbv5y7LXPNymR0B48uTq4mdj16LCakBfzAYyolcf6ZYUKcUl9q/vMNWIe7QAuw6AQ2lHS1ixuBQegl4Yj8oJgmQOa1YvXrGxULqgxsKCMn+X2+PThEm/4rZvvZJarqRsFk9wUnRV7c=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?ndEEXnZMc8BY3bWvbTpHWHDBIXE/h5uYM96I59Ca1iJbhWajAi8bmx6c6pxT?=
 =?us-ascii?Q?GoxgVuuJGRRUvV5nuvfHQ/lFUQ2ftjKMSuid0qmcK9lLPXeZu09lgEgyqaHQ?=
 =?us-ascii?Q?IZynRnT0qpeY4L9y5TU9Elm6J+uoN6WjuLQwEvGZUjMdP25w6UHaWKNAcW3h?=
 =?us-ascii?Q?g626maOcm4cCg+yT11pWSiuazRyUqpqdnrmcOu+DyqtP+U3hWW7iDl7cQNpC?=
 =?us-ascii?Q?Ewf3oput6Z7cOy11fSCzDhMxNstrB7YKbXxTtHTjpzGoxouGt7Mg18hQsB6U?=
 =?us-ascii?Q?22tM7P/SRzB6SJyG1G8fryVCC73llLZy52rY5DGCVHDG0R0rAc/ljEx8FPDi?=
 =?us-ascii?Q?e7Nyl7WkXj0wZqzH2fDL9wgmfqpbZFDKa6C8su8rD6ejb43/vrWbOYzmvqt8?=
 =?us-ascii?Q?KRXnfSZObFOetEEDSmnGsq3OvihDGYPvz9+BFbnZGmeyioae4ardOMlJFmGF?=
 =?us-ascii?Q?lUk5EDMFOOROdf8VzdBCihiSLovfSsEKKx4gsdQV57sSGX0yAF5PGAWveMY8?=
 =?us-ascii?Q?4YtVFAABph83NYE0cGtZeGA4ak7kzKdZIAcJtK5uQqtsbET7d72kwEsYUciR?=
 =?us-ascii?Q?MGe8okZg2Z1kWfj8jSONyZ6m2F87WOXeJ+XlrjZQ2kB6Dp7J1ZpyytgkNyQ+?=
 =?us-ascii?Q?VakL2BsClhEFscCPmLXx7/+KZfrBOGM/zusQgksYy3eK3cWuxKW0exjq0WcJ?=
 =?us-ascii?Q?TUkUO9qz5NAe3UnTirw3uJo5zs/6SWWa0p3JlbYW3mYtvbKPeQ74nowd2cGH?=
 =?us-ascii?Q?2WWC73pRAKueO0qEeCTdRBmorqUAMoFJt2dGOqSjs4xX0CxBgIkLJkpj2qok?=
 =?us-ascii?Q?qsJ30M+KqaiCK1wLSHvM4PdJBkOWdkhA8BHJDzCm5s8bcJ1hv+NKONW/f0Va?=
 =?us-ascii?Q?cE2G6poXavIeQ28lBLS3pWx4SvWc5Y/KVfGs1om+n+Jh5tC99fc1mkSNL/HK?=
 =?us-ascii?Q?Z3tVoHfnHEcLBz9X/6gUaWruD2b3F9PHEi7038OHshmo5KzUlYeCW7XbDnby?=
 =?us-ascii?Q?7pO5nH85Ug42FrrFHsW6wTRuoLE2O4UvNZQktoJwFgRwLCyUJXqCQ82fS7Or?=
 =?us-ascii?Q?9Hzbr4CPzZPA8fJe/0tOvnh1l/d+QZAv/QB7pc4CaQrMCNUpNgxuCbSJFME4?=
 =?us-ascii?Q?KTW6ugLwHlsmfnZjPdTdO1JlBDCKwbzA6wgDHu+UQUhcK8uqZzMw81i1M+hM?=
 =?us-ascii?Q?ehdaQwGKBt2nJ8XnNYEmBvn5Y60mzPIQDEySFmDsBJa0YypfTTFw91a1PJdm?=
 =?us-ascii?Q?QR6qzW/YLMMb9h/n0uu/z9L7bhdFArtOBqSJR6rufMhLj2Bf0OL3YIgyrT4w?=
 =?us-ascii?Q?QWw/iaYjUJY8GruTk/yASNhugkOD1TEGvb2QWDzd7RO0TwhSiyZxFQeeeIZG?=
 =?us-ascii?Q?qG9IGf1k6DCwe+Sob5xafYzctqAIlRVrctvraJL6F4uvKj4IIlzEttJULwah?=
 =?us-ascii?Q?Lx7iIDyvycWJAX/O4tpiEynZdCajHGr6Th4cTden0S0+ivziKWPslFRFMBAC?=
 =?us-ascii?Q?rdkH7SSdr7Qk74hq3ITEnZbUSLEluFXpsLdtr4zxlh5bFdsNlvW12+tuepCE?=
 =?us-ascii?Q?BNdtQ2AGrrw8rEEsNW2Fl+VF0oMiW+RFxxeCzpNO?=
X-MS-Exchange-CrossTenant-Network-Message-Id:
 2cd03e54-a1a1-49b8-d3a4-08db7657531f
X-MS-Exchange-CrossTenant-AuthSource: PA4PR04MB7997.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName:
 SjVje/cQLRDWltZ/pkRUQCsDPdnhKxo2RC8l+5/a6GDw4qpMKQv5Z2CsOderpgcqm8L2rTdbdjAKdBqO0Khkcw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB8746
X-ServerName: mail-am7eur03on2077.outbound.protection.outlook.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf.suse.com include:amazonses.com
 include:spf.protection.outlook.com include:_spf.qemailserver.com
 include:_spf.salesforce.com -all
X-Spam: Clean
X-Proofpoint-ORIG-GUID: ndnw6ahDsLbQqjZIGJ9XhQP3n6pQDU-K
X-Proofpoint-GUID: ndnw6ahDsLbQqjZIGJ9XhQP3n6pQDU-K
Reporting-Meta:
 AAECMX7AONLZl4hmM8/YsnydvjeQa4B9vwKZQaztMyMwtpxlKhyxHmM+i6rgeFjl
 J+hIdyGhd721AMf+KigSapcuO7NAjAGLIyY06+osQfpQOcrUa16FMlGp1kjsC4fg
 aDvNRxhsIpW86wK+Nv431bPhYa0BQdkPNNigDgMwULl8VRtxMYh3uOuigFAlIlqf
 rycK4wWVY3Xtzsb1kcVBQpVz4n2wkAgdva7JrDNv3On60aUDsnc8uCKY6YdSagrd
 WYsnOimS/FZatZ7wpYNAe8g7aNXvpYbFkUOOU9b3Xn1VafpjRvviMHQeFPyMF/At
 J58INN2aX4zs23HtN3pd9nCoJzF8GD/j2ogzlQ/GWITQp8V+OtDwWH9VOoK/tkP1
 w6t0U3ksbSOEW8CT86TNH8hzqDS00fa70jP+RnQ65fnuAHZcLdAHX6tKk59l4vRW
 aL7tKddED9KHNfY7tCw37JydYFYX1C3x6avcLCPCvrFJwfeMcObzL4i3oV/Y4dRa
 I4sdtcWRhmErslVMCz/sVAejy+3I3tt56j3qWWboJleJjg==

(sorry for last mail with mess format, resend)

On Mon, Jun 26, 2023 at 07:24:53PM +0800, Heming Zhao wrote:
> fstest generic cases 347 361 628 629 trigger a same issue:
> When jbd2 enter ABORT status, ocfs2 ignores it and keep going to commit
> journal. This issue causes umount failure (hanging).
> 
> This commit gives ocfs2 ability to handle jbd2 ABORT case. After
> patching, umount successfully and leave journal dirty status.
> 
> Signed-off-by: Heming Zhao <heming.zhao@suse.com>
> ---
> v2:
>    (this v2 only for patch [2/2], see below URL)
>    add description in commit log.
>    don't reset ->j_num_trans and leave journal dirty status on disk.
> 
> v1: https://oss.oracle.com/pipermail/ocfs2-devel/2023-April/000896.html
> ---
>  fs/ocfs2/alloc.c      | 10 ++++++----
>  fs/ocfs2/journal.c    | 17 +++++++++++++++--
>  fs/ocfs2/journal.h    |  5 +++--
>  fs/ocfs2/localalloc.c |  3 +++
>  4 files changed, 27 insertions(+), 8 deletions(-)
> 

It looks I found 2 bugs when testing this patch.
1> fsck.ocfs2 doesn't succeed to repair unclean jbd2 data but output successfully.
2> fsck.ocfs2 doesn't remove dlm lockspace when exit.

** how to trigger **

first do below steps:
(/dev/vdg size should bigger than 1GB)
(these steps derived from fstest generic 361)
```
mkfs -t ocfs2 -F -N 4 --cluster-stack pcmk --cluster-name tst -b 4096 /dev/vdg 131072
mount -t ocfs2 /dev/vdg /fstest/scratch
/sbin/xfs_io -i -fc 'truncate 1g' /fstest/scratch/fs.img
mkdir /fstest/scratch/mnt
losetup -f --show /fstest/scratch/fs.img
losetup --direct-io=on /dev/loop0
mkfs -t ocfs2 -N 4 /dev/loop0
mount -t ocfs2 /dev/loop0 /fstest/scratch/mnt

/sbin/xfs_io -i -fc 'pwrite 0 520m' /fstest/scratch/mnt/testfile
/usr/bin/mount -o remount,ro /fstest/scratch/mnt

umount /fstest/scratch/mnt  (<-- trigger jbd2 abort)
```

The last 'umount' will trigger jbd2 enter abort status, then leave unclean
journal data on disk.
Then using fsck.ocfs2 repair this loop0 device, this software output
'successfully', but the real status is this partition still fails to mount.

```
tb-fstest1:~ # mount -t ocfs2 /dev/loop0 /fstest/scratch/mnt
mount.ocfs2: Internal logic failure while mounting /dev/loop0 on /fstest/scratch/mnt. Check 'dmesg' for more information on this error 5.

tb-fstest1:~ # fsck.ocfs2 /dev/loop0
fsck.ocfs2 1.8.7
Checking OCFS2 filesystem in /dev/loop0:
  Label:              <NONE>
  UUID:               4990448088164475A620ACD486ACFC8E
  Number of blocks:   262144
  Block size:         4096
  Number of clusters: 262144
  Cluster size:       4096
  Number of slots:    4

/dev/loop0 wasn't cleanly unmounted by all nodes.  Attempting to replay the journals for nodes that didn't unmount cleanly
Checking each slot's journal.
Replaying slot 0's journal.
*** There were problems replaying journals.  Be careful in telling fsck to make repairs to this filesystem.
Slot 0's local alloc replayed successfully
/dev/loop0 is clean.  It will be checked after 20 additional mounts.
Slot 0's journal dirty flag removed

tb-fstest1:~ # mount -t ocfs2 /dev/loop0 /fstest/scratch/mnt
mount.ocfs2: Internal logic failure while mounting /dev/loop0 on
/fstest/scratch/mnt. Check 'dmesg' for more information on this
error 17.

tb-fstest1:~ # ls /sys/kernel/dlm/
0B90A8FBD12C4ED3BB947682045C8B51  4990448088164475A620ACD486ACFC8E

tb-fstest1:~ # ps axj |grep ocfs2
2  1232     0     0 ?           -1 I<       0   0:00 [ocfs2_wq]
2  1233     0     0 ?           -1 S        0   0:00 [ocfs2dc-0B90A8FBD12C4ED3BB947682045C8B51]
2  1240     0     0 ?           -1 S        0   0:00 [ocfs2cmt-0B90A8FBD12C4ED3BB947682045C8B51]

tb-fstest1:~ # dlm_tool leave 4990448088164475A620ACD486ACFC8E
Leaving lockspace "4990448088164475A620ACD486ACFC8E"
done

tb-fstest1:~ # mount -t ocfs2 /dev/loop0 /fstest/scratch/mnt
mount.ocfs2: Internal logic failure while mounting /dev/loop0 on /fstest/scratch/mnt. Check 'dmesg' for more information on this error 5.
```

Thanks,
Heming

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
