<?php

declare(strict_types=1);

namespace App\Home\Type;

use App\Home\Model\UserId;
use Doctrine\DBAL\ParameterType;
use Doctrine\DBAL\Platforms\AbstractPlatform;
use Doctrine\DBAL\Types\Type;

class UserIdType extends Type {
    public const string NAME = 'user_id';

    public function convertToPHPValue($value, AbstractPlatform $platform): ?UserId {
        /** @var int|null $intValue */
        $intValue = parent::convertToPHPValue($value, $platform);
        return $intValue === null ? null : new UserId($intValue);
    }

    public function convertToDatabaseValue(mixed $value, AbstractPlatform $platform): ?int {
        $dbValue = null;
        if ($value instanceof UserId) {
            $dbValue = $value->toInt();
        }

        return parent::convertToDatabaseValue($dbValue, $platform);
    }

    public function getSQLDeclaration(array $column, AbstractPlatform $platform): string {
        return $platform->getIntegerTypeDeclarationSQL($column);
    }

    public function getBindingType(): ParameterType {
        return ParameterType::INTEGER;
    }

    public function getName(): string {
        return self::NAME;
    }
}
